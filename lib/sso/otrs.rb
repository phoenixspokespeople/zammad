# Copyright (C) 2012-2013 Zammad Foundation, http://zammad-foundation.org/

module Sso::Otrs
  def self.check( params, _config_item )

    endpoint = Setting.get('import_otrs_endpoint')
    return false if !endpoint
    return false if endpoint.empty?
    return false if endpoint == 'http://otrs_host/otrs'
    return false if !params['SessionID']

    # connect to OTRS
    result = Import::OTRS.session( params['SessionID'] )

    return false if !result
    return false if !result['groups_ro']
    return false if !result['groups_rw']
    return false if !result['user']

    user = User.where( login: result['user']['UserLogin'], active: true ).first

    if !user
      Rails.logger.info "No such user #{result['user']['UserLogin']}, requested for SSO!"
      return
    end

    user
  end
end
