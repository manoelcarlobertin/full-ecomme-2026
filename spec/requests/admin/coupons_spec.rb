require 'rails_helper'

RSpec.describe "Admin::Coupons", type: :request do
  let(:user) { create(:user, profile: :admin) }

  # CORREÇÃO 1: Adicionamos o 'scope: :user' para ajudar o Devise
  before { sign_in user, scope: :user }

  describe "GET /admin/coupons" do
    it "returns http success" do
      create_list(:coupon, 3)
      get admin_coupons_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/coupons" do
    context "with valid params" do
      let(:coupon_params) { attributes_for(:coupon) }

      it "creates a new Coupon" do
        expect {
          post admin_coupons_path, params: { coupon: coupon_params }
        }.to change(Coupon, :count).by(1)
      end

      it "redirects to the coupons list" do
        post admin_coupons_path, params: { coupon: coupon_params }
        expect(response).to redirect_to(admin_coupons_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { attributes_for(:coupon, name: nil) }

      it "does not create a new Coupon" do
        expect {
          post admin_coupons_path, params: { coupon: invalid_params }
        }.not_to change(Coupon, :count)
      end

      it "renders the :new template (unprocessable entity)" do
        post admin_coupons_path, params: { coupon: invalid_params }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /admin/coupons/:id" do
    let(:coupon) { create(:coupon) }

    context "with valid params" do
      let(:new_name) { "Black Friday 2026" }

      it "updates the requested coupon" do
        patch admin_coupon_path(coupon), params: { coupon: { name: new_name } }
        coupon.reload
        expect(coupon.name).to eq(new_name)
      end

      it "redirects to the coupons list" do
        patch admin_coupon_path(coupon), params: { coupon: { name: new_name } }
        expect(response).to redirect_to(admin_coupons_path)
      end
    end

    context "with invalid params" do
      it "does not update the coupon" do
        old_name = coupon.name
        patch admin_coupon_path(coupon), params: { coupon: { name: nil } }
        coupon.reload
        expect(coupon.name).to eq(old_name)
      end
    end
  end

  describe "DELETE /admin/coupons/:id" do
    let!(:coupon) { create(:coupon) }

    it "destroys the requested coupon" do
      expect {
        delete admin_coupon_path(coupon)
      }.to change(Coupon, :count).by(-1)
    end

    it "redirects to the coupons list" do
      delete admin_coupon_path(coupon)
      expect(response).to redirect_to(admin_coupons_path)
    end
  end

  describe "Security access" do
    let(:client_user) { create(:user, profile: :client) }

    # CORREÇÃO 2: Adicionamos o 'scope: :user' aqui também
    before { sign_in client_user, scope: :user }

    it "redirects clients to root path" do
      get admin_coupons_path
      expect(response).to redirect_to(root_path)
    end
  end
end
