# frozen_string_literal: true

module TwoFactorAuthentication
  # TwoFactorAuthentication::Test::IntegrationHelpers is a helper module for facilitating
  # two-factor authentication on Rails integration tests to bypass the required steps for
  # entering OTP codes.
  #
  # Examples
  #
  #  class PostsTest < ActionDispatch::IntegrationTest
  #    include Devise::Test::IntegrationHelpers
  #    include TwoFactorAuthentication::Test::IntegrationHelpers
  #
  #    test 'authenticated users can see posts' do
  #      sign_in_with_2fa users(:bob)
  #
  #      get '/posts'
  #      assert_response :success
  #    end
  #  end
  module Test
    module IntegrationHelpers

      # Signs in a specific resource without needing two-factor authentication,
      # mimicking a successful sign in operation through +Devise::SessionsController#create+.
      #
      # * +resource+ - The resource that should be authenticated
      # * +scope+    - An optional +Symbol+ with the scope where the resource
      #                should be signed in with.
      def sign_in_with_2fa(resource, scope: nil)
        cookie_name = TwoFactorAuthentication::REMEMBER_TFA_COOKIE_NAME
        dummy_cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
        dummy_cookies.signed[cookie_name] = "#{resource.class}-#{resource.public_send(Devise.second_factor_resource_id)}"
        cookies[cookie_name] = dummy_cookies[cookie_name]
        sign_in(resource, scope: scope)
      end

    end
  end
end