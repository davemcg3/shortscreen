class LinksController < ApplicationController
  before_action :authenticate, only: [:index, :destroy]
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    redirect_to new_link_url and return unless (session[:authenticated] == true)
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
    redirect_to new_link_url unless @link.present?
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to link_path(admin_code: @link.admin_code), notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    modified_params = link_params.to_h.symbolize_keys
    modified_params[:expired_at] = Time.zone.now if (link_params[:expired_at] == "true")

    respond_to do |format|
      if @link.update(modified_params)
        format.html { redirect_to link_path, admin_code: @link.admin_code, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    redirect_to new_link_url and return unless (session[:authenticated] == true)
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /fedcba
  # GET /fedcba.json
  def visit
    @link = Link.active.find_by_short_code(params[:short_code])
    if @link.present?
      HitWorker.perform_async(@link.id, Time.zone.now, request.user_agent)
      redirect_to @link.destination, status: :moved_permanently and return
    end
    raise ActionController::RoutingError.new('Not Found')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find_by_admin_code(params[:admin_code])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:destination, :short_code, :admin_code, :use_count, :expired_at)
    end
end
