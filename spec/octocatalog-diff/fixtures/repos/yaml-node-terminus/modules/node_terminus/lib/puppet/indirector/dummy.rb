require 'hiera'
require 'puppet/node'
require 'puppet/indirector/none'

class Puppet::Node::Dummy < Puppet::Indirector::None
  desc 'Get node information from Hiera. Queries the keys "environment", "classes" and "parameters".'

  def find(request)
    facts = Puppet::Node::Facts.indirection.find(request.key)
    node = Puppet::Node.new(
      request.key,
      :classes     => hiera.lookup('classes', [], facts.values, nil, :array)
    )
    node.fact_merge
    node
  end
end
