defmodule Changelog.FastlyTest do
	use ExUnit.Case

  import Mock

  describe "purge/1" do
  	test "when given a url string" do
  		with_mock(HTTPoison, request: fn _, _, _, _ -> %{status_code: 200} end) do
  			url = "https://cdn.changelog.com/uploads/podcast/1/the-changelog-1.mp3"
  			Changelog.Fastly.purge(url)
  			assert called(HTTPoison.request(:purge, "https://api.fastly.com/uploads/podcast/1/the-changelog-1.mp3", "", host: "cdn.changelog.com"))
  		end
  	end
  end
end
