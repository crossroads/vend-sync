require File.dirname(__FILE__) + '/../spec_helper'

describe Vend::Sync::Import do
  let(:account) { 'account' }
  let(:username) { 'username' }
  let(:password) { 'password' }

  subject { described_class.new(account, username, password) }

  describe '#import' do
    it 'should import outlets' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/outlets').to_return(
        body: File.read('spec/fixtures/outlets.json')
      )
      subject.import(:Outlet)
      Vend::Sync::Outlet.count.should eql(2)
    end

    it 'should import products' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/products').to_return(
        body: File.read('spec/fixtures/products.json')
      )
      subject.import(:Product)
      Vend::Sync::Product.count.should eql(1)
    end

    it 'should import customers' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/customers').to_return(
        body: File.read('spec/fixtures/customers.json')
      )
      subject.import(:Customer)
      Vend::Sync::Customer.count.should eql(2)
    end

    it 'should import payment types' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/payment_types').to_return(
        body: File.read('spec/fixtures/payment_types.json')
      )
      subject.import(:PaymentType)
      Vend::Sync::PaymentType.count.should eql(5)
    end

    it 'should import registers' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/registers').to_return(
        body: File.read('spec/fixtures/registers.json')
      )
      subject.import(:Register)
      Vend::Sync::Register.count.should eql(2)
    end

    it 'should import register sales' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/register_sales?page_size=200').to_return(
        body: File.read('spec/fixtures/register_sales.json')
      )
      subject.import(:RegisterSale)
      Vend::Sync::RegisterSale.count.should eql(1)
      Vend::Sync::RegisterSaleProduct.count.should eql(2)
    end

    it 'should import taxes' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/taxes').to_return(
        body: File.read('spec/fixtures/taxes.json')
      )
      subject.import(:Tax)
      Vend::Sync::Tax.count.should eql(3)
    end

    it 'should import users' do
      stub_request(:get, 'https://username:password@account.vendhq.com/api/users').to_return(
        body: File.read('spec/fixtures/users.json')
      )
      subject.import(:User)
      Vend::Sync::User.count.should eql(1)
    end
  end
end