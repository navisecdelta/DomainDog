#!/usr/bin/env ruby

require 'mechanize'
require 'nokogiri'
require 'optparse'
require 'ruby-progressbar'
require './lib/domain_dog.rb'

trap "SIGINT" do
  puts "\nBye Bye, thanks for using DomainDog by Navisec Delta :)"
  exit 130
end

ARGV << '-h' if ARGV.empty?

options = {}
optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
    opts.banner = "Usage: dog.rb " 
    # Define the options, and what they do

    options[:query] = false
    opts.on( '-s', '--search email@company.com', 'Query for reverse whois' ) do|query|
        options[:query] = query
    end


    options[:outfile] = false
    opts.on( '-o', '--outfile domains.txt', 'File to save the results' ) do|outfile|
        options[:outfile] = outfile
    end
    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end
end

optparse.parse!

if options[:query]
banner = %q{ ____                        _       ____              
|  _ \  ___  _ __ ___   __ _(_)_ __ |  _ \  ___   __ _ 
| | | |/ _ \| '_ ` _ \ / _` | | '_ \| | | |/ _ \ / _` |
| |_| | (_) | | | | | | (_| | | | | | |_| | (_) | (_| |
|____/ \___/|_| |_| |_|\__,_|_|_| |_|____/ \___/ \__, |
                                                 |___/
Author: pry0cc | NaviSec Delta | delta.navisec.io
    }
    puts banner
    puts "[*] Initializing DomainDog..."
    dog = DomainDog.new()

    puts "[+] Starting reverse whois lookup against #{options[:query]}"
    puts ""

    domains = dog.reverse_whois(options[:query])

    if options[:outfile]
        file = File.open(options[:outfile], "w+")
        domains.each do |domain|
            file.write(domain + "\n")
        end
        file.close
        puts "[+] Domain saved to #{options[:outfile]}"
    else
        puts domains
    end
end


