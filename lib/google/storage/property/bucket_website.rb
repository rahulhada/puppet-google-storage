# Copyright 2017 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ----------------------------------------------------------------------------
#
#     ***     AUTO GENERATED CODE    ***    AUTO GENERATED CODE     ***
#
# ----------------------------------------------------------------------------
#
#     This file is automatically generated by puppet-codegen and manual
#     changes will be clobbered when the file is regenerated.
#
#     Please read more about how to change this file in README.md and
#     CONTRIBUTING.md located at the root of this package.
#
# ----------------------------------------------------------------------------

require 'puppet/property'

module Google
  module Storage
    module Data
      # A class to manage data for website for bucket.
      class BucketWebsite
        include Comparable

        attr_reader :main_page_suffix
        attr_reader :not_found_page

        def to_json(_arg = nil)
          {
            'mainPageSuffix' => main_page_suffix,
            'notFoundPage' => not_found_page
          }.reject { |_k, v| v.nil? }.to_json
        end

        def to_s
          {
            main_page_suffix: main_page_suffix,
            not_found_page: not_found_page
          }.reject { |_k, v| v.nil? }.map { |k, v| "#{k}: #{v}" }.join(', ')
        end

        def ==(other)
          return false unless other.is_a? BucketWebsite
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            return false if compare[:self] != compare[:other]
          end
          true
        end

        def <=>(other)
          return false unless other.is_a? BucketWebsite
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            result = compare[:self] <=> compare[:other]
            return result unless result.zero?
          end
          0
        end

        private

        def compare_fields(other)
          [
            { self: main_page_suffix, other: other.main_page_suffix },
            { self: not_found_page, other: other.not_found_page }
          ]
        end
      end

      # Manages a BucketWebsite nested object
      # Data is coming from the GCP API
      class BucketWebsiteApi < BucketWebsite
        def initialize(args)
          @main_page_suffix =
            Google::Storage::Property::String.api_munge(args['mainPageSuffix'])
          @not_found_page =
            Google::Storage::Property::String.api_munge(args['notFoundPage'])
        end
      end

      # Manages a BucketWebsite nested object
      # Data is coming from the Puppet manifest
      class BucketWebsiteCatalog < BucketWebsite
        def initialize(args)
          @main_page_suffix = Google::Storage::Property::String.unsafe_munge(
            args['main_page_suffix']
          )
          @not_found_page = Google::Storage::Property::String.unsafe_munge(
            args['not_found_page']
          )
        end
      end
    end

    module Property
      # A class to manage input to website for bucket.
      class BucketWebsite < Puppet::Property
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          Data::BucketWebsiteCatalog.new(value)
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          Data::BucketWebsiteApi.new(value)
        end
      end
    end
  end
end