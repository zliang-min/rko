#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'init'

require 'nokogiri'

html_segment = <<_HTML_
<style type="text/css">
  .body {font: 'sens';}
</style>
<script type="text/javascript">
  // this is a script segment
  alert('hello');
</script>
<div id="article">
  <h3 class="title" onclick="void(0);">This is title</h3>
  <div class="body" onclick="alert('shit');">
    <p>body goes here</p>
    <p style="color:red">This is another paragraph.</p>
    <p id="piss" class="shit" style="color:blue;background-img:url(b.png);" ondbclick="alert('you fool')">
      yet another paragraph.
    </p>
    <script type="anyscript">what will happen here?</script>
  </div>
</div>
_HTML_

invalid_tags = %w[style script emb object]
invalid_attrs = /^on|^(style|id|class)$/i

(h = Nokogiri::HTML::DocumentFragment.parse html_segment).traverse do |node|
  if invalid_tags.include?(node.name)
    node.remove 
    next
  end
  node.attribute_nodes.each do |attr|
    attr.remove if invalid_attrs === attr.name
  end
end

puts h.to_html
puts '---'
puts h.to_s
