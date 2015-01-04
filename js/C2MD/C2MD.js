var C2MD = {};

C2MD.initialize = function()
{
  C2MD.XSL = Saxon.requestXML("xslt/c2md.xsl");
};

C2MD.parseConfluenceStorageFormatStringAsDOM = function(doc, str) {

	var WRAPPER_TOP = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			+ "<!DOCTYPE ac:confluence SYSTEM \"dtd/confluence-all.dtd\" [ "
			+ "<!ENTITY clubs    \"&#9827;\">"
			+ "<!ENTITY nbsp   \"&#160;\">"
			+ "<!ENTITY ndash   \"&#8211;\">"
			+ "<!ENTITY mdash   \"&#8212;\">"
			+ " ]>"
			+ "<ac:confluence xmlns:ac=\"http://www.atlassian.com/schema/confluence/4/ac/\" xmlns:ri=\"http://www.atlassian.com/schema/confluence/4/ri/\" xmlns=\"http://www.atlassian.com/schema/confluence/4/\">";
	var WRAPPER_BOTTOM = "</ac:confluence>";

	var strConfluenceXMLDoc = WRAPPER_TOP + str + WRAPPER_BOTTOM;
	var xml;

	if (window.ActiveXObject) {
		// Creating the new empty DOM tree:
		xml = new ActiveXObject("MSXML2.DOMDocument.6.0");
		// No asynchronous load:
		xml.async = false;
		xml.preserveWhiteSpace = true;
		xml.resolveExternals = true;
		xml.setProperty("ProhibitDTD", false);
		xml.loadXML(strConfluenceXMLDoc);
		if (xml.parseError.errorCode !== 0) {
			throw xml.parseError;
		}
	} else if (doc.implementation
			&& doc.implementation.createDocument) {
		var strError = "";
		var parser = new DOMParser();
		xml = parser
				.parseFromString(strConfluenceXMLDoc, "application/xml");
		if (xml.documentElement.nodeName == "parsererror") {
			var strError = xml.documentElement.childNodes[0].nodeValue;
			throw new Error(strError);
		} else {
			var errors = xml.getElementsByTagName("parsererror");
			if (errors.length > 0) {
				throw new Error(errors[0].textContent);
			}
		}
	}
	return xml;
};

C2MD.transformConfluenceStorageFormatDOMToMarkdownString = function(doc, xml) {
  var processor= Saxon.newXSLT20Processor();
  processor.importStylesheet(C2MD.XSL);
  var markdownDOM = processor.transformToFragment(xml, doc);
  var markdownString = markdownDOM.textContent;
  return markdownString;
};

C2MD.transformConfluenceStorageFormatStringToMarkdownString = function(doc, str) {
  var confluenceStorageFormatDOM = C2MD.parseConfluenceStorageFormatStringAsDOM(doc, str);
  var confluenceStorageFormatMarkdownString = C2MD.transformConfluenceStorageFormatDOMToMarkdownString(doc, confluenceStorageFormatDOM);
  return confluenceStorageFormatMarkdownString;
};