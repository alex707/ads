class AdvertisementParamsContract < Dry::Validation::Contract
  params do
    required(:advertisement).hash do
      required(:title).value(:string)
      required(:description).value(:string)
      required(:city).value(:string)
    end
  end
end
