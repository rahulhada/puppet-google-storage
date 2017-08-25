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

require 'google/hash_utils'
require 'google/storage/network/delete'
require 'google/storage/network/get'
require 'google/storage/network/post'
require 'google/storage/network/put'
require 'google/storage/property/bucket_name'
require 'google/storage/property/bucketaccesscontrol_project_team'
require 'google/storage/property/enum'
require 'google/storage/property/string'
require 'puppet'

Puppet::Type.type(:gstorage_bucket_access_control).provide(:google) do
  mk_resource_methods

  def self.instances
    debug('instances')
    raise [
      '"puppet resource" is not supported at the moment:',
      'TODO(nelsonjr): https://goto.google.com/graphite-bugs-view?id=167'
    ].join(' ')
  end

  def self.prefetch(resources)
    debug('prefetch')
    resources.each do |name, resource|
      project = resource[:project]
      debug("prefetch #{name}") if project.nil?
      debug("prefetch #{name} @ #{project}") unless project.nil?
      fetch = fetch_resource(resource, self_link(resource),
                             'storage#bucketAccessControl')
      resource.provider = present(name, fetch) unless fetch.nil?
    end
  end

  def self.present(name, fetch)
    result = new({ title: name, ensure: :present }.merge(fetch_to_hash(fetch)))
    result
  end

  def self.fetch_to_hash(fetch)
    {
      bucket:
        Google::Storage::Property::BucketNameRef.api_munge(fetch['bucket']),
      domain: Google::Storage::Property::String.api_munge(fetch['domain']),
      email: Google::Storage::Property::String.api_munge(fetch['email']),
      entity: Google::Storage::Property::String.api_munge(fetch['entity']),
      entity_id: Google::Storage::Property::String.api_munge(fetch['entityId']),
      id: Google::Storage::Property::String.api_munge(fetch['id']),
      project_team: Google::Storage::Property::BuckAcceContProjTeam.api_munge(
        fetch['projectTeam']
      ),
      role: Google::Storage::Property::Enum.api_munge(fetch['role'])
    }.reject { |_, v| v.nil? }
  end

  def exists?
    debug("exists? #{@property_hash[:ensure] == :present}")
    @property_hash[:ensure] == :present
  end

  def create
    debug('create')
    @created = true
    create_req = Google::Storage::Network::Post.new(collection(@resource),
                                                    fetch_auth(@resource),
                                                    'application/json',
                                                    resource_to_request)
    return_if_object create_req.send, 'storage#bucketAccessControl'
    @property_hash[:ensure] = :present
  end

  def destroy
    debug('destroy')
    @deleted = true
    delete_req = Google::Storage::Network::Delete.new(self_link(@resource),
                                                      fetch_auth(@resource))
    return_if_object delete_req.send, 'storage#bucketAccessControl'
    @property_hash[:ensure] = :absent
  end

  def flush
    debug('flush')
    # return on !@dirty is for aiding testing (puppet already guarantees that)
    return if @created || @deleted || !@dirty
    update_req = Google::Storage::Network::Put.new(self_link(@resource),
                                                   fetch_auth(@resource),
                                                   'application/json',
                                                   resource_to_request)
    return_if_object update_req.send, 'storage#bucketAccessControl'
  end

  def dirty(field, from, to)
    @dirty = {} if @dirty.nil?
    @dirty[field] = {
      from: from,
      to: to
    }
  end

  private

  def self.resource_to_hash(resource)
    {
      project: resource[:project],
      name: resource[:name],
      kind: 'storage#bucketAccessControl',
      bucket: resource[:bucket],
      domain: resource[:domain],
      email: resource[:email],
      entity: resource[:entity],
      entity_id: resource[:entity_id],
      id: resource[:id],
      project_team: resource[:project_team],
      role: resource[:role]
    }.reject { |_, v| v.nil? }
  end

  def resource_to_request
    request = {
      kind: 'storage#bucketAccessControl',
      bucket: @resource[:bucket],
      entity: @resource[:entity],
      entityId: @resource[:entity_id],
      projectTeam: @resource[:project_team],
      role: @resource[:role]
    }.reject { |_, v| v.nil? }
    debug "request: #{request}" unless ENV['PUPPET_HTTP_DEBUG'].nil?
    request.to_json
  end

  def fetch_auth(resource)
    self.class.fetch_auth(resource)
  end

  def self.fetch_auth(resource)
    Puppet::Type.type(:gauth_credential).fetch(resource)
  end

  def debug(message)
    puts("DEBUG: #{message}") if ENV['PUPPET_HTTP_VERBOSE']
    super(message)
  end

  def self.collection(data)
    URI.join(
      'https://www.googleapis.com/storage/v1/',
      expand_variables(
        'b/{{bucket}}/acl',
        data
      )
    )
  end

  def collection(data)
    self.class.collection(data)
  end

  def self.self_link(data)
    URI.join(
      'https://www.googleapis.com/storage/v1/',
      expand_variables(
        'b/{{bucket}}/acl/{{entity}}',
        data
      )
    )
  end

  def self_link(data)
    self.class.self_link(data)
  end

  def self.return_if_object(response, kind)
    raise "Bad response: #{response}" \
      unless response.is_a?(Net::HTTPResponse)
    return if response.is_a?(Net::HTTPNotFound)
    return if response.is_a?(Net::HTTPNoContent)
    result = JSON.parse(response.body)
    raise_if_errors result, %w[error errors], 'message'
    raise "Bad response: #{response}" unless response.is_a?(Net::HTTPOK)
    raise "Incorrect result: #{result['kind']} (expected '#{kind}')" \
      unless result['kind'] == kind
    result
  end

  def return_if_object(response, kind)
    self.class.return_if_object(response, kind)
  end

  def self.extract_variables(template)
    template.scan(/{{[^}]*}}/).map { |v| v.gsub(/{{([^}]*)}}/, '\1') }
            .map(&:to_sym)
  end

  def self.expand_variables(template, var_data, extra_data = {})
    data = if var_data.class <= Hash
             var_data.merge(extra_data)
           else
             resource_to_hash(var_data).merge(extra_data)
           end
    extract_variables(template).each do |v|
      unless data.key?(v)
        raise "Missing variable :#{v} in #{data} on #{caller.join("\n")}}"
      end
      template.gsub!(/{{#{v}}}/, CGI.escape(data[v].to_s))
    end
    template
  end

  def self.fetch_resource(resource, self_link, kind)
    get_request = ::Google::Storage::Network::Get.new(
      self_link, fetch_auth(resource)
    )
    return_if_object get_request.send, kind
  end

  def self.raise_if_errors(response, err_path, msg_field)
    errors = ::Google::HashUtils.navigate(response, err_path)
    raise_error(errors, msg_field) unless errors.nil?
  end

  def self.raise_error(errors, msg_field)
    raise IOError, ['Operation failed:',
                    errors.map { |e| e[msg_field] }.join(', ')].join(' ')
  end
end