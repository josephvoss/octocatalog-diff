# frozen_string_literal: true

# Set node_terminus option to pass to puppet during puppet catalog compile. If
# not set the default plain terminus option will be used. This option will be
# overwritten by the --enc options

# @param parser [OptionParser object] The OptionParser argument
# @param options [Hash] Options hash being constructed; this is modified in this method.

OctocatalogDiff::Cli::Options::Option.newoption(:node_terminus) do
  has_weight 400

  def parse(parser, options)
    parser.on('--node-terminus NODE_TERMINUS',
              'Node terminus to pass to puppet compilation') do |i|
      options[:node_terminus] = i
    end
  end
end
