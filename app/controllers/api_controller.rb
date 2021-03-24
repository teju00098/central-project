class ApiController < ActionController::API
    protected
    def authenticate_access
      if request.headers["XTOKEN"].present?
        @current_user = User.find_by_access_token(request.headers["XTOKEN"])
      end
      
      unless current_user
        render json: {error: "Unauthorized access"}, status: 401   
      end 
    end
  
    def current_user
      @current_user
    end
  end
  