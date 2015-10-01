#!/usr/bin/env ruby

# version 2015-09-30 GAO port to Raspberry PI

require 'optparse'
require 'pp'

def justify(options, word)
    case options[:justify]
    when :left
        txt = sprintf("%-*s", options[:width], word)
    when :right
        txt = sprintf("%*s", options[:width], word)
    when :center
        left  = (options[:width] - word.size    ) / 2
        right = (options[:width] - word.size) / 2
        unless left + right + word.size == options[:width]
            left += 1
        end
        txt = sprintf("%*s%s%*s", left, '', word, right, '')
    end
    txt
end

def header(options)
    puts '*'*(options[:width]+8)
end

def footer(options)
    puts '*'*(options[:width]+8)
end

def line(options, word)
    printf("*** %s ***\n", justify(options, word))
end

exit_code = 0
options   = { :justify => :left }

opts = OptionParser.new do |opts|

    opts.banner << ' STRING [STRING [...]]'

    opts.on_tail(' ')
    opts.on_tail('Where:')
    opts.on_tail(' ')

    opts.on_tail('-j', '--join', 'Join all non-option argument(s) together into a string, separated by spaces.') do |o|
        options[:join] = o
    end

    opts.on_tail('-l', '--left', 'Multiple line strings are justified on the left, padded with spaces on the right.') do |o|
        options[:justify] = :left
    end

    opts.on_tail('-r', '--right', 'Multiple line strings are justified on the right, padded with spaces on the left.') do |o|
        options[:justify] = :right
    end

    opts.on_tail('-c', '--center', 'Multiple line strings are centered on each line, padded with spaces on the lft and/or right.') do |o|
        options[:justify] = :center
    end

    opts.on_tail('-h', '--help', 'Displays this help text.') do |o|
        puts opts
        exit_code = 1
    end

    opts.on_tail(' ')
    opts.on_tail('And:')
    opts.on_tail(' ')
    opts.on_tail('    STRING                           Is a unicode string.')
    opts.on_tail(' ')
end

rest = nil
begin
    rest = opts.parse!
rescue OptionParser::InvalidOption => ex
    puts "\nSyntax error: #{ex}"
    exit_code = 2
end

unless exit_code > 0
    #pp options
    #pp rest
    if options[:join]
        words = [ rest.join(' ') ]
    else
        words = rest
    end

    max_len = words.inject(0) { |max_len, i| max_len > i.size ? max_len : i.size }
    options[:width] = max_len

    header(options)
    words.each do |word|
        line(options, word)
    end
    footer(options)
end
