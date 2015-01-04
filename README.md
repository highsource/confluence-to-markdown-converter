# Confluence to Markdown converter

This project is developing a tool to to convert Confluence pages into Markdown.

# The goal

I have a lot of Confluence content which I'd like to move to GitHub wiki. I failed to find an adequate tool to do this so I'll have to implement one.

# The idea

The easiest way to do it seems to be to export pages in the [Confluence Storage Format](https://confluence.atlassian.com/display/DOC/Confluence+Storage+Format) (which is XHTML based, i.e. valid XML) and to transform them into Markdown using XSLT. There's a similar tool [available](http://www.amnet.net.au/~ghannington/confluence/wikifier/), but unfortunately its output is not exactly suitable for GitHub Wikis.

# Related links

* [Wikifier](http://www.amnet.net.au/~ghannington/confluence/wikifier/)