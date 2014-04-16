require File.dirname(__FILE__) + '/../spec_helper'

describe Vend::Sync::Import do
  let(:account) { 'account' }
  let(:username) { 'username' }
  let(:password) { 'password' }

  subject { described_class.new(account, username, password) }

  describe '#import' do
    it 'should import outlets' do
      stub_request(:get, %r{/api/outlets}).to_return(
        body: File.read('spec/fixtures/outlets.json')
      )
      subject.import(:Outlet)
      count(:outlets).should eql(2)
    end

    it 'should import products' do
      stub_request(:get, %r{/api/products}).to_return(
        body: File.read('spec/fixtures/products.json')
      )
      subject.import(:Product)
      count(:products).should eql(1)
    end

    it 'should import customers' do
      stub_request(:get, %r{/api/customers}).to_return(
        body: File.read('spec/fixtures/customers.json')
      )
      subject.import(:Customer)
      count(:customers).should eql(2)
    end

    it 'should import payment types' do
      stub_request(:get, %r{/api/payment_types}).to_return(
        body: File.read('spec/fixtures/payment_types.json')
      )
      subject.import(:PaymentType)
      count(:payment_types).should eql(5)
    end

    it 'should import registers' do
      stub_request(:get, %r{/api/registers}).to_return(
        body: File.read('spec/fixtures/registers.json')
      )
      subject.import(:Register)
      count(:registers).should eql(2)
    end

    it 'should import register sales updated since the last import' do
      stub_request(:get, %r{/api/register_sales\?page_size=200}).to_return(
        body: File.read('spec/fixtures/register_sales.json')
      )
      stub_request(:get, %r{/api/register_sales/since/2010-09-03\+15:10:30\?page_size=200}).to_return(
        body: '{"register_sales": []}'
      )
      subject.import(:RegisterSale)
      subject.import(:RegisterSale)
      count(:register_sales).should eql(1)
      count(:register_sale_products).should eql(2)
    end

    it 'should import taxes' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/taxes').to_return(
        body: File.read('spec/fixtures/taxes.json')
      )
      subject.import(:Tax)
      count(:taxes).should eql(3)
    end

    it 'should import users' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/users').to_return(
        body: File.read('spec/fixtures/users.json')
      )
      subject.import(:User)
      count(:users).should eql(1)
    end
  end

  def count(table_name)
    ActiveRecord::Base.connection.select_value(
      "select count(*) from #{table_name}"
    ).to_i
  end
end