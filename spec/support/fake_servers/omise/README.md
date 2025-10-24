# Fake Omise Server

This fake server mocks the Omise API for testing payment flows without making real API calls.

## Architecture

The FakeServer uses:
- **Sinatra** for Rack-based HTTP routing
- **WebMock's `to_rack()`** to intercept HTTP requests in tests
- **JSON templates** for different charge scenarios

## Directory Structure

```
spec/support/fake_servers/omise/
├── application.rb          # Main Sinatra app
├── jsons/                  # JSON response templates
│   ├── charge.json         # Pending charge template
│   ├── charge_paid.json    # Successful paid charge template
│   └── [custom].json       # Add your own scenarios
└── README.md              # This file
```

## How It Works

1. **WebMock intercepts** requests to `api.omise.co`
2. **Routes to Sinatra app** via `to_rack(FakeServers::Omise::Application)`
3. **Loads JSON templates** and merges with request params
4. **Returns mocked responses** to the Omise Ruby gem

## Available Endpoints

### POST /charges
Creates a new charge.

**Request params:**
- `amount` - Amount in smallest currency unit (e.g., 8000 for ฿80.00)
- `currency` - Currency code (default: "thb")
- `return_uri` - URL to redirect after 3DS authentication
- `card` - Token for card payment

**Response:** Pending charge (from `charge.json`)

### GET /charges/:id
Retrieves a charge by ID.

**Response:** Paid charge (from `charge_paid.json`)

### GET /fake-3ds/authorize/:charge_id
Simulates 3DS authorization page (optional, for testing actual redirects).

**Response:** HTTP redirect to `return_uri`

## Creating Custom Scenarios

To test different payment scenarios, create new JSON template files:

### Example: Failed Charge

Create `jsons/charge_failed.json`:
```json
{
  "object": "charge",
  "authorized": false,
  "paid": false,
  "status": "failed",
  "failure_code": "insufficient_fund",
  "failure_message": "Insufficient funds in account",
  ...
}
```

Then use it in your test:
```ruby
# In spec setup or helper
allow(FakeServers::Omise::Application).to receive(:create_charge)
  .and_wrap_original { |m, *args|
    m.call(*args, template: "charge_failed.json")
  }
```

### Example: 3DS Required Charge

Create `jsons/charge_3ds_required.json`:
```json
{
  "object": "charge",
  "authorized": false,
  "paid": false,
  "status": "pending",
  "authorize_uri": "http://localhost:3000/fake-3ds/authorize/...",
  ...
}
```

## Testing Tips

### Reset Between Tests
The FakeServer automatically resets charges before each test via the `webmock.rb` configuration.

### Access Stored Charges
For debugging, you can inspect stored charges:
```ruby
FakeServers::Omise::Application.class_variable_get(:@@charges)
```

### Custom Templates Per Test
Override the template in specific tests:
```ruby
it "handles failed payments" do
  allow(FakeServers::Omise::Application).to receive(:retrieve_charge)
    .and_wrap_original { |m, *args|
      m.call(*args, template: "charge_failed.json")
    }

  # Your test code...
end
```

## Template Variables

These values are dynamically replaced when loading templates:

- `id` - Generated charge ID (e.g., `chrg_test_abc123`)
- `location` - Charge location path
- `amount` - From request params
- `currency` - From request params or template default
- `authorize_uri` - From request `return_uri`
- `return_uri` - From request params
- `card.id` - Generated card ID
- `created` - Current timestamp
- `transaction` - Generated when charge is retrieved

## Common Scenarios

### Successful Payment Flow
1. POST /charges → Returns pending charge
2. Redirect to `authorize_uri` (skipped in tests, goes to return_uri)
3. GET /charges/:id → Returns paid charge ✅

### Failed Payment
1. POST /charges → Returns charge with failure_code
2. Handle error in controller ❌

### 3DS Authentication
1. POST /charges → Returns charge with authorize_uri
2. Visit authorize_uri → Redirects to return_uri
3. GET /charges/:id → Returns paid charge ✅

## Troubleshooting

**"Host not permitted" error:**
- Ensure `set :environment, :test` is in `application.rb`

**Template not found:**
- Check file exists in `jsons/` directory
- Verify filename matches what's passed to `template:` parameter

**Charge not persisting:**
- Charges are stored in `@@charges` class variable
- They persist within a single test but reset between tests
