require 'spec_helper'
require 'securerandom'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if many are returned by the API, all are shown at the page" do
    cty = "helsinki"
    mestat = BeermappingApi.places_in(cty)

    visit places_path
    fill_in('city', with: cty)
    click_button "Search"

    mestat.each do |m|
      expect(page).to have_content m.name
    end
  end

  it "if none are returned by the API, none are shown at the page" do
    cty=SecureRandom.hex(32)
    visit places_path
    fill_in('city', with: cty)
    click_button "Search"

    expect(page).to have_content "No locations in " + cty
  end
end
