# frozen_string_literal: true

require_relative 'integration_helper'

describe 'a catalog-only operation' do
  before(:all) do
    @repo_dir = OctocatalogDiff::Spec.fixture_path('repos/yaml-node-terminus')
    @result = OctocatalogDiff::Integration.integration(
      spec_fact_file: 'facts.yaml',
      output_format: :json,
      argv: [
        '--basedir', @repo_dir,
        '--hiera-config', File.join(@repo_dir, 'config/hiera.yaml'),
        '--catalog-only',
        '-n', 'rspec-node.github.net',
        '--node-terminus', 'yaml',
        '-o', '/tmp/test-catalog.yaml'
      ]
    )
  end

  it 'should compile the catalog' do
    expect(@result[:exitcode]).not_to eq(-1), OctocatalogDiff::Integration.format_exception(@result)
    expect(@result[:exitcode]).to eq(0), "Runtime error: #{@result[:logs]}"
  end

  it 'should have log messages indicating catalog compilations' do
    pending 'catalog compilation failed' unless (@result[:exitcode]).zero?
    logs = @result[:logs]
    expect(logs).to match(/Compiling catalog for rspec-node.github.net/)
    expect(logs).to match(/Success build_catalog for ./)
  end

  it 'should produce a valid catalog' do
    pending 'catalog compilation failed' unless (@result[:exitcode]).zero?
    to_catalog = @result.to
    expect(to_catalog.valid?).to eq(true)
    expect(to_catalog.to_h).to be_a_kind_of(Hash)
    expect(to_catalog.to_json).to be_a_kind_of(String)
    expect(to_catalog.error_message).to be(nil)
  end

  it 'should produce the expected catalog' do
    pending 'catalog compilation failed' unless @result.exitcode.zero?
    to_catalog = @result.to

    param1 = { 'owner' => 'root', 'group' => 'root', 'mode' => '0644', 'content' => 'Testy McTesterson' }
    expect(to_catalog.resource(type: 'File', title: '/tmp/foo')['parameters']).to eq(param1)

    param2 = { 'content' => 'Temporary file' }
    expect(to_catalog.resource(type: 'File', title: '/tmp/bar')['parameters']).to eq(param2)

    param3 = { 'content' => 'test' }
    expect(to_catalog.resource(type: 'File', title: '/tmp/baz')['parameters']).to eq(param3)
  end
end
