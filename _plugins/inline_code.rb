## taken from https://github.com/imathis/octopress/tree/master/plugins
## NOTE: need to be reimported from github because version of this file does not correspond to version of pygments_code.rb


# Title: Include Code Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
# Configuration: You can set default import path in _config.yml (defaults to code_dir: downloads/code)
#
# Syntax {% include_code path/to/file %}
#
# Example 1:
# {% include_code javascripts/test.js %}
#
# This will import test.js from source/downloads/code/javascripts/test.js
# and output the contents in a syntax highlighted code block inside a figure,
# with a figcaption listing the file name and download link
#
# Example 2:
# You can also include an optional title for the <figcaption>
#
# {% include_code javascripts/test.js Example 2 %}
#
# will output a figcaption with the title: Example 2 (test.js)
#

require './_plugins/pygments_code'
require 'pathname'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    include HighlightCode
    def initialize(tag_name, markup, tokens)
      @file = nil
      @title_old = nil

      opts     = parse_markup(markup)
      @options = {
        lang:      opts[:lang],
        title:     opts[:title],
        lineos:    opts[:lineos],
        marks:     opts[:marks],
        url:       opts[:url],
        link_text: opts[:link_text] || 'view raw',
        start:     opts[:start]     || 1,
        end:       opts[:end]
      }
      markup     = clean_markup(markup)

      if markup.strip =~ /(^\S*\.\S+) *(.+)?/i
        @file = $1
        @options[:title] ||= $2
      elsif markup.strip =~ /(.*?)(\S*\.\S+)\Z/i # Title before file is deprecated in 2.1
        @title_old = $1
        @file = $2
      end
      super
    end

    def render(context)
      code_dir = '_includes'#(context.registers[:site].config['code_dir'].sub(/^\//,'') || 'downloads/code')
      code_path = (Pathname.new(context.registers[:site].source) + code_dir).expand_path
      filepath = code_path + @file

      unless @title_old.nil?
        @options[:title] ||= @title_old
        puts "### ------------ WARNING ------------ ###"
        puts "This include_code syntax is deprecated "
        puts "Correct syntax: path/to/file.ext [title]"
        puts "Update include for #{filepath}"
        puts "### --------------------------------- ###"
      end

      if File.symlink?(code_path)
        puts "Code directory '#{code_path}' cannot be a symlink"
        return "Code directory '#{code_path}' cannot be a symlink"
      end

      unless filepath.file?
        puts "File #{filepath} could not be found"
        return "File #{filepath} could not be found"
      end

      Dir.chdir(code_path) do
        @options[:lang]  ||= filepath.extname.sub('.','')
        @options[:title]   = @options[:title] ? "#{@options[:title]} (#{filepath.basename})" : filepath.basename
        @options[:url]   ||= "/#{code_dir}/#{@file}"

        code = filepath.read
        code = get_range(code, @options[:start], @options[:end])
        highlight(code, @options)
      end
    end
    
    def parse_markup (input)
      lang      = input.match(/\s*lang:(\w+)/i)
      title     = input.match(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      linenos   = input.match(/\s*linenos:(\w+)/i)
      escape    = input.match(/\s*escape:(\w+)/i)
      marks     = get_marks(input)
      url       = input.match(/\s*url:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      link_text = input.match(/\s*link[-_]text:\s*(("(.+?)")|('(.+?)')|(\S+))/i)
      start     = input.match(/\s*start:(\d+)/i)
      endline   = input.match(/\s*end:(\d+)/i)

      opts = {
        lang:         (lang.nil? ? nil : lang[1]),
        title:        (title.nil? ? nil : title[3] || title[5] || title[6]),
        linenos:      (linenos.nil? ? nil : linenos[1]),
        escape:       (escape.nil? ? nil : escape[1]),
        marks:        marks,
        url:          (url.nil? ? nil : url[3] || url[5] || url[6]),
        start:        (start.nil? ? nil : start[1].to_i),
        end:          (endline.nil? ? nil : endline[1].to_i),
        link_text:    (link_text.nil? ? nil : link_text[3] || link_text[5] || link_text[6])
      }
      opts.merge(parse_range(input, opts[:start], opts[:end]))
    end

    def clean_markup (input)
      input.sub(/\s*lang:\s*\w+/i, ''
        ).sub(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*url:\s*(\S+)/i, ''
        ).sub(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i, ''
        ).sub(/\s*mark:\d\S*/i,''
        ).sub(/\s*linenos:\s*\w+/i,''
        ).sub(/\s*start:\s*\d+/i,''
        ).sub(/\s*end:\s*\d+/i,''
        ).sub(/\s*range:\s*\d+-\d+/i,'')
    end

    def get_marks (input)
      # Matches pattern for line marks and returns array of line numbers to mark
      # Example input mark:1,5-10,2
      # Outputs: [1,2,5,6,7,8,9,10]
      marks = []
      if input =~ / *mark:(\d\S*)/i
        marks = $1.gsub /(\d+)-(\d+)/ do
          ($1.to_i..$2.to_i).to_a.join(',')
        end
        marks = marks.split(',').collect {|s| s.to_i}.sort
      end
      marks
    end
  
    def parse_range (input, start, endline)
      if input =~ / *range:(\d+)-(\d+)/i
        start = $1.to_i
        endline = $2.to_i
      end
      {start: start, end: endline}
    end

    def get_range (code, start, endline)
      length    = code.lines.count
      start   ||= 1
      endline ||= length
      if start > 1 or endline < length
        raise "#{filepath} is #{length} lines long, cannot begin at line #{start}" if start > length
        raise "#{filepath} is #{length} lines long, cannot read beyond line #{endline}" if endline > length
        code = code.split(/\n/).slice(start - 1, endline + 1 - start).join("\n")
      end
      code
    end   

  end
end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)

