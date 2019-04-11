require 'hiera'
require 'puppet/node'
require 'puppet/indirector/none'

class Puppet::Node::Dummy < Puppet::Indirector::None
  desc 'Get node information from Hiera. Queries the keys "environment", "classes" and "parameters".'

  def find(request)
    node = Puppet::Node.new(
      request.key,
      #:classes     => hiera.lookup('classes', [], facts.values, nil, :array)
      :classes     => Puppet::Util::Yaml.load_file(path(request.key))['classes']
    )
    node.fact_merge
    node
  end
end
