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

    puts "Downloading day #{day} (#{year}) - #{name}"

    FileUtils.mkdir_p(path)
    File.write("#{path}/input", input)
    File.write("#{path}/part1.rb", SOLUTION_STUB)
  end

  desc 'runner DAY PART', 'Run solution for advent of code'
  def runner(day = Time.now.day, part = 1)
    year = options[:year]
    name = challenge_name(year, day)
    path = "#{year}/#{day} - #{name}"
    file = "./#{path}/part#{part}.rb"

    puts "Running day #{day} (#{year}) - #{name} (pt #{part})"

    raise NotFoundError, "#{file} does not exist" unless File.exist?(file)

    puts `ruby "#{file}"`
  end

  def self.exit_on_failure?
    true
  end
end

AdventOfCodeCLI.start(ARGV)
