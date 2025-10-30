FactoryBot.define do
  factory :company do
    name { "Company name Test" }
    address_1    { "Company address_1 Test" }
    address_2    { "Company address_2 Test" }
    sub_district { "Company sub_district Test" }
    district     { "Company district Test" }
    province     { "Company province Test" }
    postal_code  { "Company postal_code Test" }
    country      { "Company country Test" }
    phone_number { "Company phone_number Test" }
    email        { "Company email Test" }
  end
end
