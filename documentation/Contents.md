dom.hx - A Haxe Library for manipulating Xml and the DOM across platforms.
==========================================================================

^^ - means functionality is not finished yet.

General Usage

 * "using dom.HX"
 * traversing
 * element manipulation
 * dom manipulation
 * ^^ events
 * ^^ style
 * ^^ animation

Cross Platform

 * JS specific
 * Haxe Xml targets
 	* Neko
 	* ^^ Flash
 	* ^^ PHP
 	* ^^ CPP
 	* ^^ Java
 	* ^^ C#
 * ^^ NodeJS - ? what do we do here?
 * Macro runtime

Concepts

 * Collections and Nodes
 * Widgets / DataWidgets

Widgets

 * Introduction (what, why?)
 * Setting up a widget manually
 * Extending a widget class
 * Examples
 * Setting up a widget using templates
 * ^^ Partials
 	* ^^ Reference by fully qualified classname, or class in the same package
 	* ^^ Partial further down the page in the same template file
 	* ^^ <$MyWidget /> -> could be a class (or template which will turn into a class) with the same package path
 	     <$some.package.MyWidget> -> a widget / class with a different path
 	     <$SomePartial /> -> a partial taken from further down the same page (takes precedence over files)
 	     <partial name="MyWidget">Some Code</partial>

 	     QUESTIONS:
 	     * do these partial widgets get passed any constructor values?
 	       eg. <$MyButton args="(name, 'save()', Colour.Green)" />
 	     * do these partial widgets get associated with a class property (from data widgets)
 	       eg. <$MyButton inject="obj.property" />
 	       if (obj.property != null) -> widget.insert-at-location(obj.property);
 	       ... Or is that completely normal?
 	       <div>$myButton</div>
 	       (where $myButton is a widget instance to be imported?)

Data Widgets

 * Introduction (what, why?)
 * Templating / variable interpolation
 	* Basic setup (defining classes, templates, setting variables etc)
 	* Text Nodes
 		* Variables
 		* Properties
 		* Methods
 		* Haxe Expressions
 	* Attributes
 		* Variables, properties etc
 		* ^^ Boolean attributes
 		* Expressions (<p class="${isRed?'red':'blue'}">)
 	* ^^ "if" Blocks
 		* ^^ Purpose, example
 		* ^^ Setting up
 			* ^^ <div if="showContent">Inline Content</div>
 			* ^^ <div if="showContent" partial="SomePartial"></div>
 		* ^^ Else <div if="showContent" partial="TruePartial" else="FalsePartial"></div>
 	* "^^ for" Blocks
 		* ^^ Purpose, example
 		* ^^ How to set it up, pass variables
 			* ^^ Using inline template
 			* ^^ Using partial
 		* ^^ Else <div for="item in list" partial="ListItemPartial" else="NoItemsPartial">
 * Data Objects
 	* What is supported (basic class objects, properties)
 	* Supporting more complex property types
 		* toString()
 		* ^^ Using partials for custom templates
