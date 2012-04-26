/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

package domtools.single;

import js.w3c.level3.Core;
/*
wrap()
unwrap
wrapAll()
wrapInner()
detach() - removes element, but keeps data
replaceAll(selector) - replace each element matching selector with our collection
replaceWith(newContent) - replace collection with new content
*/ 


/** This class could do with some more DRY - Don't Repeat Yourself.  I feel like between 
append() and insertBefore() there should be no need for any other functions */

class DOMManipulation
{
	/** Append the specified child to this node */
	static public function append(parent:DOMNode, ?childNode:DOMNode = null, ?childCollection:DOMCollection = null)
	{
		if (parent != null)
		{
			if (childNode != null)
			{
				parent.appendChild(childNode);
			}
			if (childCollection != null)
			{
				for (child in childCollection)
				{
					parent.appendChild(child);
				}
			}
		}

		return parent;
	}

	/** Prepend the specified child to this node */
	static public function prepend(parent:DOMNode, ?newChildNode:DOMNode = null, ?newChildCollection:DOMCollection = null)
	{
		if (parent != null)
		{
			if (newChildNode != null)
			{
				if (parent.hasChildNodes())
				{
					insertThisBefore(newChildNode, parent.firstChild);
				}
				else 
				{
					append(parent, newChildNode);
				}
			}
			if (newChildCollection != null)
			{
				domtools.collection.DOMManipulation.insertThisBefore(newChildCollection, parent.firstChild);
			}
		}

		return parent;
	}

	/** Append this node to the specified parent */
	static public function appendTo(child:DOMNode, ?parentNode:DOMNode = null, ?parentCollection:DOMCollection = null)
	{
		if (parentNode != null)
		{
			append(parentNode, child);
		}
		if (parentCollection != null)
		{
			domtools.collection.DOMManipulation.append(parentCollection, child);
		}

		return child;
	}

	/** Prepend this node to the specified parent */
	static public inline function prependTo(child:DOMNode, ?parentNode:DOMNode = null, ?parentCollection:DOMCollection = null)
	{
		if (parentNode != null)
		{
			if (parentNode.hasChildNodes())
			{
				insertThisBefore(child, parentNode.firstChild, parentCollection);
			}
			else 
			{
				append(parentNode, child);
			}
		}
		if (parentCollection != null)
		{
			domtools.collection.DOMManipulation.prepend(parentCollection, child);
		}
		return child;
	}

	static public function insertThisBefore(content:DOMNode, ?targetNode:DOMNode = null, ?targetCollection:DOMCollection = null)
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				targetNode.parentNode.insertBefore(content, targetNode);
			}
			if (targetCollection != null)
			{
				var firstChildUsed = false;
				for (target in targetCollection)
				{
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;
					target.parentNode.insertBefore(childToInsert, target);
					
					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	static public inline function insertThisAfter(content:DOMNode, ?targetNode:DOMNode, ?targetCollection:DOMCollection)
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				if (targetNode.nextSibling != null)
				{
					targetNode.parentNode.insertBefore(content, targetNode.nextSibling);
				}
				else 
				{
					targetNode.parentNode.appendChild(content);
				}
			}
			if (targetCollection != null)
			{
				var firstChildUsed = false;
				for (target in targetCollection)
				{
					// clone the child if we've already used it
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;
					
					if (target.nextSibling != null)
					{
						// add the (possibly cloned) child after.the target
						// (that is, before the targets next sibling)
						target.parentNode.insertBefore(childToInsert, target.nextSibling);
					}
					else 
					{
						// add the (possibly cloned) child after the target
						// by appending it to the very end of the parent
						append(target.parentNode, childToInsert);
					}
					
					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	static public function beforeThisInsert(target:DOMNode, ?contentNode:DOMNode, ?contentQuery:DOMCollection)
	{
		if (target != null)
		{
			if (contentNode != null)
			{
				insertThisBefore(contentNode, target);
			}
			if (contentQuery != null)
			{
				domtools.collection.DOMManipulation.insertThisBefore(contentQuery, target);
			}
		}

		return target;
	}

	static public function afterThisInsert(target:DOMNode, ?contentNode:DOMNode, ?contentQuery:DOMCollection)
	{
		if (target != null)
		{
			if (contentNode != null)
			{
				insertThisAfter(contentNode, target);
			}
			if (contentQuery != null)
			{
				domtools.collection.DOMManipulation.insertThisAfter(contentQuery, target);
			}
		}
		
		return target;
	}

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function remove(childToRemove:DOMNode)
	{
		if (childToRemove != null && childToRemove.parentNode != null)
		{
			childToRemove.parentNode.removeChild(childToRemove);
		}
		return childToRemove;
	}

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function removeChildren(parent:DOMNode, ?childToRemove:DOMNode, ?childrenToRemove:DOMCollection)
	{
		if (parent != null)
		{
			if (childToRemove != null && childToRemove.parentNode == parent)
			{
				parent.removeChild(childToRemove);
			}
			if (childrenToRemove != null)
			{
				for (child in childrenToRemove)
				{
					if (child.parentNode == parent)
					{
						parent.removeChild(child);
					}
				}
			}
		}
		return parent;
	}

	/** Empty the current element of all children. */
	static public function empty(container:DOMNode)
	{
		if (container != null)
		{
			while (container.hasChildNodes())
			{
				container.removeChild(container.firstChild);
			}
		}
		return container;
	}
}

