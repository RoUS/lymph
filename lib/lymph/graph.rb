# -*- coding: utf-8 -*-
#--
#   Copyright © 2016 Ken Coar
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#++

require('rubygems')
require('ruby-graphviz')

module Lymph

  class Graph

    attr_accessor(:graph)
    attr_accessor(:node)
    attr_accessor(:edges)
    attr_accessor(:models)

    def initialize(*args)
      if (! defined?(::Rails))
        raise(RuntimeError, 'can only produce graphs within a Rails application')
      end
      Lymph.load_definitions
      @node		= {}
      @edges		= []
      @models		= Lymph.definitions['models']
      name		= Rails.application.class.name.sub(%r!::Application$!, '')
      @graph		= GraphViz.digraph(name, :label => name, :fontsize => 12)
      @models.each do |mname,mrec|
        node		= @graph.add_node(mname, :label => mname, :fontsize => 10)
        @node[mname]	= node
      end
      @models.each do |mname,mrec|
        next unless (mrec.key?('connexions') && (cxlist = mrec['connexions']))
        cxlist.each do |celt|
          edge		= @graph.add_edge(mname, celt['foreign_model'],
                                          :label	=> celt['relation'].to_s,
                                          :fontname	=> 'monospace',
                                          :fontsize	=> 8)
          (celt['options'] || {}).each do |op,val|
            if (celt['options']['polymorphic'])
              edge.color = 'green'
              edge.arrowhead = :veevee
            end
          end
          @edges	<< edge
        end
      end
    end                         # def initialize

  end                           # class Graph

  def graph!
    digraph		= Graph.new
    dotfile		= File.join(Rails.root, 'tmp', 'models.dot')
    File.open(dotfile, 'w') { |io|
      io.puts(digraph.graph.to_s)
    }
    puts("Model relationship graph generated in #{dotfile}")
    return true
  end                           # def graph!
  module_function(:graph!)

end                             # model Lymph
