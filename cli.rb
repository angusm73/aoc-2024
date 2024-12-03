# frozen_string_literal: true

require 'thor'
require 'fileutils'
require './lib/advent_of_code_helper'

# Advent of Code helper CLI
class AdventOfCodeCLI < Thor
  include AdventOfCodeHelper

  class_option :year, type: :numeric, default: Time.now.year

  desc 'download DAY', 'Download daily advent of code'
  def download(day = Time.now.day)
    year  = options[:year]
    name  = challenge_name(year, day)
    input = download_input(year, day)
    path  = "#{year}/#{day} - #{name}"

    puts "Downloading day #{day} - #{name}"

    FileUtils.mkdir_p(path)
    File.write("#{path}/input", input)
    File.write("#{path}/part1.rb", SOLUTION_STUB)
  end

  def self.exit_on_failure?
    true
  end
end

AdventOfCodeCLI.start(ARGV)
