/* * * * * * * * * * * * * * * * * * * * * *
 *                                         *
 *   GenDocs 2.1 SciTE version             *
 *      Template.ahk - This file contains  *
 *         the documentation template.     *
 *   This file is part of GenDocs 2.1      *
 * * * * * * * * * * * * * * * * * * * * * *
 */

charset := A_IsUnicode ? "utf-8" : "iso-8859-1"

template =
(LTrim Join`r`n
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>[FuncName]</title>
<meta http-equiv="Content-Type" content="text/html; charset=%charset%">
<link href="commands.css" rel="stylesheet" type="text/css">
</head>
<body>

<h1>[FuncName]</h1>
<p>[Description]</p>

<pre class="Syntax">[Syntax]</pre>
<h3>Parameters</h4>
[ParamTable]
<h3>Return Value</h4>
[ReturnValue]
<h3>Remarks</h4>
<p>[Remarks]</p>
<h3>Related</h4>
<p>[LinksToRelatedPages]</p>
<h3>Example</h4>
<pre class="NoIndent">[Example]</pre>

</body>
</html>
)

ptemplate =
(LTrim Join`r`n
<table class="info">
[ParamTable]
</table>
)

tabletemplate =
(LTrim Join`r`n
  <tr>
    <td width="15`%">[ParamName]</td>
    <td width="85`%"><p>[ParamDescription]</p></td>
  </tr>
)

css_commands =
(LTrim Join`r`n
/* styles tweaked from the original AutoHotkey css */

body {
	font-family: Verdana, Arial, Helvetica, sans-serif, "MS sans serif";
	font-size: 75`%;
	border: 0;
	background-color: #FFFFFF;
    line-height: 145`%;
}
p {
	margin-top: 0.7em;
	margin-bottom: 0.7em;
}

h1 {
	font-size: 155`%;
	font-weight: normal;
	margin: 0;
    padding: 0 0 0.5em 4px;
	border-bottom-style: ridge;
    border-bottom-color: #FFFFFF;
    border-bottom-width: 2px;
}
h2 {
	font-size: 144`%;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif, "MS sans serif";
	background-color: #405871;
	color: #FFFFFF;
	margin: 1.5em 0 0.5em 0;
	padding: 0.1em 0 0.1em 0.2em;
}
h3 {
	font-size: 111`%;
	font-weight: bold;
	background-color: #E6E6E6;
	margin: 1.0em 0 0.5em 0;
	padding: 0.1em 0 0.1em 0.2em;
	border-top: 1px solid silver;
	border-bottom: 1px solid silver;
}
h4 {
    font-size: 100`%;
    margin: 0.7em 0;
    border-bottom: 1px solid lightgrey;
}

ul, ol {margin-top: 0.7em; margin-bottom: 0.7em;}
li {margin-top: 0.2em; margin-bottom: 0.2em; margin-left: -0.75em;}

a {text-decoration: none;}
a:link, a:active {color: #0000AA;}
a:visited {color: #AA00AA;}
a:hover {text-decoration: underline; color: #6666CC;}

.Indent {
    margin-left: 2em;
}
.NoIndent {
	margin-left: 0;
	margin-right: 0;
}

/* pre: code blocks, code: inline code, .Syntax: syntax definition (block/pre or inline/span) */
pre, code, .Syntax {
	font-family: Consolas, Courier New, monospace;
}
pre, code { background-color: #F3F3FF; border: solid 1px #E3E3EF; }
.Syntax   { background-color: #FFFFAA; border: solid 1px #E8E89A; }
code, span.Syntax { padding: 0 1px; }
pre {
    margin: 0.7em 1.5em 0.7em 1.5em;
    padding: 0.7em 0 0.7em 0.7em;
    white-space: pre-wrap; /* works in IE8 but apparently not CHM viewer */
    word-wrap: break-word; /* works in CHM viewer */
}
pre.Syntax {
    margin: 0 0 1.0em 0;
    padding: 12px 0 12px 4px;
    line-height: 150`%;
}
pre, pre.Short /*used with .Syntax*/ { line-height: 120`%; }
/* comments */
pre em, code em { color: #008000; font-style: normal; }


/* table of command parameters */
table.info {
    border: solid 2px #C0C0C0;
    border-collapse: collapse;
    width: 100`%;
    /*table-layout: fixed;*/
}
table.info td {
    border: solid 2px #C0C0C0;
    padding: 0.3em;
}
table.info th {
    background-color: #F6F6F6;
	padding: 0.3em;
}

/* version number/requirement tag */
h1 .ver, h2 .ver, h3 .ver {font-size: 65`%; font-weight: normal; margin-left: 1em; vertical-align: top}
h2 .ver {color: lightgray; font-size: 80`%;}
.ver,
/* de-emphasized */
.dull {color: gray;}
.red {color: red;} /* used for highlight in various places */
.blue {color: blue;}
/* emphasized note */
.note {border: 1px solid #99BB99; background-color: #E6FFE6;
	color: #005500; padding: 0 3px; }

/* styles for briefly documenting multiple methods on one page: */
.methodShort {
    border: solid thin #C0C0C0;
    padding: 0.5em;
    margin-bottom: 1em;
}
.methodShort h2 { margin-top: 0; }
.methodShort table.info { border: none; }
.methodShort table.info td {
    border: none;
    vertical-align: text-top;
}
.methodShort:target { /* non-essential, but helpful if it works */
    border-color: black;
}
)
