require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:one_month_product) }
  let(:order) { create(:order) }
  let(:order_item) { create(:order_item, order: order, product: product) }

  describe 'enums' do
    it 'defines state enum' do
      expect(Order.states).to eq({ 'pending' => 0, 'paid' => 1, 'cancelled' => 2 })
    end

    it 'has pending state by default' do
      expect(order.state).to eq('pending')
      expect(order.pending?).to be true
    end

    it 'allows state transitions' do
      order.paid!
      expect(order.paid?).to be true

      order.cancelled!
      expect(order.cancelled?).to be true
    end
  end

  describe '#calculated_total_cents' do
    context 'when order has a product' do
      it 'returns the product amount' do
        order_item # Create the association
        order.reload # Reload to pick up the association
        expect(order.total.cents).to eq(product.amount)
      end
    end

    context 'when order has no product' do
      it 'returns 0' do
        expect(order.total.cents).to eq(0)
      end
    end
  end

  describe '#total' do
    context 'when order is pending (unpaid)' do
      it 'returns calculated total from product' do
        order_item # Create the association
        order.reload
        expect(order.total).to be_a(Money)
        expect(order.total.cents).to eq(product.amount)
        expect(order.total.currency.to_s).to eq('THB')
      end

      it 'reflects product price changes' do
        order_item # Create the association
        order.reload
        original_amount = product.amount
        expect(order.total.cents).to eq(original_amount)

        product.update(amount: 200)
        order.reload

        expect(order.total.cents).to eq(200)
      end
    end

    context 'when order is paid' do
      it 'returns stamped total from total_cents' do
        order_item # Create the association
        order.reload
        order.update(state: :paid)
        expect(order.total).to be_a(Money)
        expect(order.total.cents).to eq(order.total_cents)
        expect(order.total.currency.to_s).to eq('THB')
      end

      it 'preserves stamped amount even if product price changes' do
        order_item # Create the association
        order.reload
        order.update(state: :paid)
        stamped_amount = order.total_cents
        expect(order.total.cents).to eq(stamped_amount)

        product.update(amount: 999)
        order.reload

        expect(order.total.cents).to eq(stamped_amount)
        expect(order.total.cents).not_to eq(999)
      end
    end
  end

  describe 'stamp_total callback' do
    context 'when transitioning to paid state' do
      it 'stamps the calculated total into total_cents' do
        order_item # Create the association
        order.reload
        expect(order.total_cents).to eq(0)

        order.update(state: :paid)

        expect(order.total_cents).to eq(product.amount)
      end
    end

    context 'when state does not change' do
      it 'does not update total_cents' do
        order_item # Create the association
        order.reload
        order.update(state: :paid)
        stamped_amount = order.total_cents

        order.update(updated_at: Time.current)
        order.reload

        expect(order.total_cents).to eq(stamped_amount)
      end
    end

    context 'when transitioning to non-paid state' do
      it 'does not stamp total_cents' do
        order.update(state: :cancelled)

        expect(order.total_cents).to eq(0)
      end
    end
  end
end
