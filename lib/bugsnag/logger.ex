defmodule Bugsnag.Logger do
  require Bugsnag
  require Logger

  use GenEvent

  def init(_mod, []), do: {:ok, []}

  def handle_call({:configure, new_keys}, _state) do
    {:ok, :ok, new_keys}
  end

  def handle_event({_level, gl, _event}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({:error_report, _gl, {_pid, _type, [message | _]}}, state) when is_list(message) do
    {_type, detail, stacktrace} = Keyword.fetch!(message, :error_info)

    Bugsnag.report(Exception.normalize(:error, detail, stacktrace), stacktrace: stacktrace)

    {:ok, state}
  end

  def handle_event({_level, _gl, _event}, state) do
    {:ok, state}
  end
end
