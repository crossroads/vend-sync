require 'spec_helper'

describe Vend::Sync::Import do
  let(:account) { 'account' }
  let(:token) { '1234567890abcdef' }

  subject { described_class.new(account, token) }

  describe '#import' do
    it 'should import outlets' do
      stub_request(:get, %r{/api/outlets}).to_return(
        body: File.read('spec/fixtures/outlets.json')
      )
      subject.import(:Outlet)
      expect(count(:outlets)).to eql(2)
    end

    it 'should import products' do
      stub_request(:get, %r{/api/products}).to_return(
        body: File.read('spec/fixtures/products.json')
      )
      subject.import(:Product)
      expect(count(:products)).to eql(1)
    end

    it 'should import customers' do
      stub_request(:get, %r{/api/customers}).to_return(
        body: File.read('spec/fixtures/customers.json')
      )
      subject.import(:Customer)
      expect(count(:customers)).to eql(2)
    end

    it 'should import payment types' do
      stub_request(:get, %r{/api/payment_types}).to_return(
        body: File.read('spec/fixtures/payment_types.json')
      )
      subject.import(:PaymentType)
      expect(count(:payment_types)).to eql(5)
    end

    it 'should import registers' do
      stub_request(:get, %r{/api/registers}).to_return(
        body: File.read('spec/fixtures/registers.json')
      )
      subject.import(:Register)
      expect(count(:registers)).to eql(2)
    end

    it 'should import register sales updated since the last import' do
      stub_request(:get, %r{/api/register_sales\?status=VOIDED}).to_return(
        body: File.read('spec/fixtures/register_sales_voided.json')
      )
      stub_request(:get, %r{/api/register_sales\?page_size=200}).to_return(
        body: File.read('spec/fixtures/register_sales.json')
      )
      stub_request(:get, %r{/api/register_sales/since/2010-09-03\+15:10:30\?page_size=200}).to_return(
        body: '{"register_sales": []}'
      )
      stub_request(:get, %r{/api/register_sales/since/2010-09-03\+15:10:30\?status=VOIDED}).to_return(
        body: '{"register_sales": []}'
      )
      subject.import(:RegisterSale)
      subject.import(:RegisterSale)
      expect(count(:register_sales)).to eql(2)
      expect(count(:register_sale_products)).to eql(2)
    end

    it 'should import taxes' do
      stub_request(:get, 'https://account.vendhq.com/api/taxes').to_return(
        body: File.read('spec/fixtures/taxes.json')
      )
      subject.import(:Tax)
      expect(count(:taxes)).to eql(3)
    end

    it 'should import users' do
      stub_request(:get, 'https://account.vendhq.com/api/users').to_return(
        body: File.read('spec/fixtures/users.json')
      )
      subject.import(:User)
      expect(count(:users)).to eql(1)
    end
  end
  
  describe "#is_date_time_field?" do
    it { expect(subject.send(:is_date_time_field?, 'year_to_date')).to eql(false) }
    it { expect(subject.send(:is_date_time_field?, 'valid_from')).to eql(true) }
    it { expect(subject.send(:is_date_time_field?, 'valid_to')).to eql(true) }
    it { expect(subject.send(:is_date_time_field?, 'date_of_birth')).to eql(true) }
  end

  def count(table_name)
    ActiveRecord::Base.connection.select_value(
      "select count(*) from #{table_name}"
    ).to_i
  end
end
