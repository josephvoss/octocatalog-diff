# frozen_string_literal: true

require_relative '../options_helper'

describe OctocatalogDiff::Cli::Options do
  describe '#opt_node_terminus' do
    it 'should accept --node-terminus' do
      result = run_optparse(['--node-terminus', 'yaml'])
      expect(result[:node_terminus]).to eq('yaml')
    end
  end
end
