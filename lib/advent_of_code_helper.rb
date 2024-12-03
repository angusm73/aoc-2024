# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv'

Dotenv.load
Dotenv.require_keys('USER_AGENT', 'AOC_SESSION')

class NotReadyError < StandardError; end

# Helpers
module AdventOfCodeHelper
  CHALLENGE_URL      = 'https://adventofcode.com/%s/day/%s'
  INPUT_DOWNLOAD_URL = 'https://adventofcode.com/%s/day/%s/input'
  AOC_USER_AGENT     = ENV['USER_AGENT']
  AOC_COOKIE         = "session=#{ENV['AOC_SESSION']}"

  SOLUTION_STUB = "input = File.read(File.join(File.dirname(__FILE__), './input'))\n\nputs input\n"

  NOT_READY_REGEX = /before it unlocks/.freeze

  def download_input(year, day)
    uri      = URI.parse(format(INPUT_DOWNLOAD_URL, year, day))
    response = get(uri)

    response.body
  end

  def challenge_name(year, day)
    uri      = URI.parse(format(CHALLENGE_URL, year, day))
    response = get(uri)

    raise NotReadyError, 'Challenge is not ready yet' if response.body.match(NOT_READY_REGEX)

    response.body.match(/--- (.*) ---/)[1].split(': ').last
  end

  private

  def get(uri)
    Net::HTTP.get_response uri, { Cookie: AOC_COOKIE, "User-Agent": AOC_USER_AGENT }
  end

end