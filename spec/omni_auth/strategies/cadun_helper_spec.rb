# encoding: utf-8
require 'spec_helper'

describe OmniAuth::Strategies::CadunHelper do
  let :controller do
    Object.new.extend(OmniAuth::Strategies::CadunHelper)
  end

  it 'should return ip from REMOTE_ADDR when it comes alone' do
    env = {'REMOTE_ADDR' =>  '200.201.0.15'}
    controller.client_ip(env).should == '200.201.0.15'
  end

  it 'should return ip from REMOTE_ADDR when HTTP_X_FORWARDED_FOR is empty' do
    env = {'REMOTE_ADDR' =>  '200.201.0.20', 'HTTP_X_FORWARDED_FOR' => ''}
    controller.client_ip(env).should == '200.201.0.20'
  end

  it 'should return ip from HTTP_X_FORWARDED_FOR when it comes alone' do
    env = {'HTTP_X_FORWARDED_FOR' =>  '201.10.0.15'}
    controller.client_ip(env).should == '201.10.0.15'
  end

  it 'should return ip from HTTP_X_FORWARDED_FOR even if REMOTE_ADDR is present' do
    env = {'REMOTE_ADDR' =>  '200.201.0.15', 'HTTP_X_FORWARDED_FOR' =>  '201.10.0.16'}
    controller.client_ip(env).should == '201.10.0.16'
  end

  it 'should always return the last ip from HTTP_X_FORWARDED_FOR' do
    env = {'HTTP_X_FORWARDED_FOR' =>  '201.10.0.15, 201.10.0.16, 201.10.0.17'}
    controller.client_ip(env).should == '201.10.0.17'
  end
end
