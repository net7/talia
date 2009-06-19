class EditionsSweeper < ActionController::Caching::Sweeper

  # called from within the SessionsController, when the user logs out
  def after_destroy
    clean_cache
  end

  # sweeps the cache of all the CriticalEdition and FacsimileEdition pages
  # this is invoked when a translator logs out, since we can't guess what's been
  # changed, in the translation, and we need to recreate the cached version of
  # everything.
  def clean_cache
    expire_fragment(%r{texts/*})
    expire_fragment(%r{facsimiles/*})
  end
end
