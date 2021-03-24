Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :admin_users
    resources :variance_reports
    resources :locations
    resources :document_products
    resources :masters
    resources :masters
    resources :uploaded_documents
    resources :master_businesses
    resources :variances
    resources :variance_master_reports
    resources :stock_variance_reports

    root to: "users#index"
  end
  resources :variances do
    get :history, on: :member
    collection do
      get :search
      post :import
      delete :cleardata
      get :stock_report
      get :stock_report_print
    end
  end

  resources :locations do
    collection do
      post :import
      delete :cleardata
      post :businessunit
    end
  end

  match "/business-form", to: "home#business_form", via: [:get, :post]

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root to: "home#home"
  resources :masters do
    collection do
      post :import
      delete :cleardata
      get :search
      get :prepare_import
      get :no_counts
      get :no_counts_print
      get :zero_counts
      get :zero_counts_print
      get :variances
      get :variances_print
      get :performance_report
      get :performance_report_print
      get :summary_report
      get :summary_report_print
    end
  end
  resources :pdamasters do
    collection do
      post :import
      delete :cleardata
      get :search
      get :prepare_import
      get :no_counts
      get :no_counts_print
      get :zero_counts
      get :zero_counts_print
      get :variances
      get :variances_print
      get :performance_report
      get :performance_report_print
    end
  end

  resources :document_products do
    collection do
      get :upload_histories
      get :bulk_import
      delete :removedata
    end
  end

  namespace :api do
    resources :files, only: %i[index] do
      collection do
        get :download_db
        post :upload_csv
        get :verify_upload
      end
    end
  end
end
