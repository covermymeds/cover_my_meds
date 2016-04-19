# Adds methods like this to your module:
#
# attr_writer :contacts_path
# def contacts_path
#   @contacts_path || "/contacts/"
# end
#
# attr_writer :contacts_host
# def contacts_host
#   @contacts_host || default_host
# end
#
# def contacts_request method, options={} &block
#   options   = options.symbolize_keys
#   path      = options[:path] || ""
#   params    = options[:params].merge({})
#   full_path = contacts_path+path
#
#   request method, contacts_host, full_path, params, &block
# end

require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/conversions'

module CoverMyMeds
  module HostAndPath
    def self.included(base)
      api_name = base.name.demodulize.underscore.downcase

      base.instance_exec do
        attr_writer "#{api_name}_path".to_sym
        define_method "#{api_name}_path" do
          instance_variable_get("@#{api_name}_path") || "/#{api_name.dasherize}/"
        end

        attr_writer "#{api_name}_host".to_sym
        define_method "#{api_name}_host" do
          instance_variable_get("@#{api_name}_host") || default_host
        end

        define_method "#{api_name}_request" do |method, options={}, &block|
          options    =  options.symbolize_keys
          path       =  options[:path] || ""
          params     =  options[:params]
          auth       =  options[:auth]
          host_name  =  public_send("#{api_name}_host".to_sym)
          full_path  =  public_send("#{api_name}_path".to_sym) + path.to_s

          proxy_args = [ method, host_name, full_path, params, auth ]
          fail ArgumentError, "method, host_name or full_path can not be nil" if proxy_args.take(3).any?(&:nil?)

          request(*proxy_args.compact, &block)
        end
      end

    end
  end
end
