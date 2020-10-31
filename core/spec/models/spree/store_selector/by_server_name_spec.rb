# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::StoreSelector::ByServerName do
  describe "#store" do
    subject { described_class.new(request).store }

    context "with a default" do
      let(:request) { double(headers: {}, env: {}) }
      let!(:store_1) { create :store, default: true }

      it "returns the default store" do
        expect(subject).to eq(store_1)
      end

      context "with a domain match" do
        let(:request) { double(headers: {}, env: { "SERVER_NAME" => url } ) }
        let(:url) { "server-name.org" }
        let!(:store_2) { create :store, default: false, url: url }

        it "returns the store with the matching domain" do
          expect(subject).to eq(store_2)
        end
      end

      context "with two domains match one" do
        let(:request) { double(headers: {}, env: { "SERVER_NAME" => 'server-name.org' } ) }
        let(:url) { "server-name.org other-name.org" }
        let!(:store_3) { create :store, default: false, url: url }

        it "returns the store with the matching domain" do
          expect(subject).to eq(store_3)
        end
      end
    end
  end
end
