class LinksController < ApplicationController

  def new
    @link = Link.new
  end

  def create
    link = Link.new create_params 
    link.length = params[:length]
    link.is_number = params[:is_number]

    if not link.save
      flash[:errors] = link.errors.full_messages
      return redirect_back(fallback_location: new_link_path)
    end

    redirect_to link_path(link.id)
  end

  def show
    @link = Link.find_by_id(params[:id])
  end

  # 识别短码后重定向到长链
  def redirect_short_url
    path = params[:path]
    link = Link.find_by_keyword(path)
    if link.present?
      link.update(hits: link.hits + 1)
      url = link.url
      return redirect_to url
    end
    render file: "#{Rails.root}/public/404"
  end

  private

  def create_params
    params.require(:link).permit(:url, :keyword)
  end

end
