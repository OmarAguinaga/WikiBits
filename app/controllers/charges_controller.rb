class ChargesController < ApplicationController
  before_action :amount_to_be_charged
  before_action :set_description
  before_action :authenticate_user!
  def create
    customer = Stripe::Customer.create(
    email: current_user.email,
    card: params[:stripeToken]
    )

    plan = Stripe::Subscription.create(
    :customer => customer.id,
    :plan => "pro",
    )


    upgrade_user(current_user)
    register_stripe_token(current_user, plan.id)
    flash[:notice] = "Thanks for upgrading your account #{current_user.email}! No as a #{current_user.role} user you have all the WikiBits features"
    redirect_to topics_path

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_charge_path
  end

  def new

    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.username}",
      amount: @amount
    }

  end

  def cancel_plan

    subscription = Stripe::Subscription.retrieve(current_user.stripe_subscription_id)
    subscription.delete(:at_period_end => true)

    downgrade_user(current_user)
    current_user_downgrade_wikis
    flash[:notice] = "Your subscription ahs been succesfully cancelled, #{current_user.email}! We will be waiting whenever you are ready to come back!"
    
    redirect_to topics_path
  end

  private

  def register_stripe_token(user, sub_id)
    user.update_attribute :stripe_subscription_id, sub_id
  end

  def amount_to_be_charged
    @amount = 9_99
  end

  def upgrade_user(user)
    user.update_attribute :role, "premium"
  end

  def downgrade_user(user)
    user.update_attribute :role, "standar"
  end
  
  def current_user_downgrade_wikis
    current_user.wikis.where(private: true).update_all(private: false)
  end 

  def set_description
    @description = "Montly Subscription"
  end
end
