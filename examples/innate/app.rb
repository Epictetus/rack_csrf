class LittleApp
  Innate.node '/'

  provide :html, :engine => :ERB

  def response
    redirect_referer unless request.post?
    @utterance, @csrf = request[:utterance, Rack::Csrf.csrf_field]
  end
end
