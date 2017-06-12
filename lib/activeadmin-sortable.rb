require 'activeadmin-sortable/version'
require 'activeadmin'
require 'rails/engine'

module ActiveAdmin
  module Sortable
    module ControllerActions
      def sortable
        member_action :sort, :method => :post do
          prev_position = params[:prev_position]
          next_position = params[:next_position]
          position = params[:position].to_i
          if prev_position && next_position
            position = [prev_position.to_i, next_position.to_i].min + 1
          elsif prev_position
            position = prev_position.to_i < resource.id ? prev_position.to_i : prev_position.to_i + 1
          elsif next_position
            position = next_position.to_i < resource.id ? next_position.to_i : next_position.to_i + 1
          end
          if defined?(::Mongoid::Orderable) &&
            resource.class.included_modules.include?(::Mongoid::Orderable)
              resource.move_to! position
          else
            resource.insert_at position
          end
          head 200
        end
      end
    end

    module TableMethods
      HANDLE = '&#x2195;'.html_safe

      def sortable_handle_column
        column '', :class => "activeadmin-sortable" do |resource|
          sort_url, query_params = resource_path(resource).split '?', 2
          sort_url += "/sort"
          sort_url += "?" + query_params if query_params
          content_tag :span, HANDLE,
                      :class => 'handle',
                      'data-sort-url' => sort_url,
                      'data-position' => resource.position
        end
      end
    end

    ::ActiveAdmin::ResourceDSL.send(:include, ControllerActions)
    ::ActiveAdmin::Views::TableFor.send(:include, TableMethods)

    class Engine < ::Rails::Engine
      # Including an Engine tells Rails that this gem contains assets
    end
  end
end


