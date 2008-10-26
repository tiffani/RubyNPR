Ruby-NPR
  by Tiffani Bell (tiffani@thinkpositif.com)
  http://the.commentari.at

== How do I install?

<tt>sudo gem i ruby-npr</tt>

== How do I get started?

<tt>@client = NPR::Client.new(:api_key => 'your NPR API key')</tt>

Pass a new Client instance your NPR API key which you can get here[http://www.npr.org/api/index].

== Accessing Stories

Use the Client#query method to find content by accessing stories directly or via lists of
stories from specific NPR topics.

<tt>@client.query(:id => 95965641)</tt>

Client#query always requires the <tt>:id</tt> option and in this particular case, this accesses
a story directly.  The Story is accessible from <tt>@client.results.list[0]</tt>.

Client#query accepts a single ID value (for either a story or a topic), as above, or a list of IDs in the form of an array.

See Client#query for more details.


== License

(The MIT License)

Copyright (c) 2008 Tiffani Bell <tiffani@thinkpositif.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.