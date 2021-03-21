Sequel.seed(:development, :test) do
  def run
    [
      ['richard_feynman', 'richard@feynman.com', '271828'],
      ['stiven_hokking', 'stiven@hokkicng.com', '332211']
    ].each do |name, email, password|
      User.create(
        name: name,
        email: email,
        password: password,
        password_confirmation: password
      )
    end
  end
end
