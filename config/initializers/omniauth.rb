Rails.application.config.middleware.use OmniAuth::Builder do

  #provider :twitter, '', ''
  #provider :linked_in, '', ''

  #development
  provider :facebook, '222424071230782', '902cce4522a3185b00a9bf7fa83f5334' if Rails.env.development?


  provider :facebook, '201393573342649', 'a79ea26219578f6d9013b1b26536433b' if Rails.env.production?

end