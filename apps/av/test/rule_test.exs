defmodule Av.RuleTest do
  use Av.DataCase

  describe "Rule.all/0" do
    test "single rule" do
      notes = [
        %{front: "hello", nid: 1}
      ]
      note = %{front: "hello", nid: 1}
      Rule.insert! %{notes: notes, note: note, rid: 1}

      actual = Rule.all
      expected = [
        %{rid: 1, name: "Repeated 'front'", total: 1, failing: 0}
      ]
      assert actual == expected
    end
  end

  describe "Rule.all/1" do
    test "first" do
      notes = [
        %{front: "hello", nid: 1}
      ]
      note = %{front: "hello", nid: 1}
      Rule.insert! %{notes: notes, note: note, rid: 1}

      actual = Rule.all 1
      expected = [
        Map.merge(note, %{rid: 1, name: "Repeated 'front'"})
      ]
      assert actual == expected
    end
  end

  describe "Rule.insert!/1" do
    test "passing" do
      notes = [
        %{front: "hello", nid: 1}
      ]
      note = %{front: "hello", nid: 1}
      Rule.insert! %{notes: notes, note: note, rid: 1}

      Rule |> Repo.all |> Enum.each(fn r ->
        refute r.fail
      end)
    end

    test "failing" do
      notes = [
        %{front: "hello", nid: 1},
        %{front: "hello", nid: 2}
      ]
      note = %{front: "hello", nid: 1}

      Rule.insert! %{notes: notes, note: note, rid: 1}

      Rule |> Repo.all |> Enum.each(fn r ->
        assert r.fail
      end)
    end
  end

  describe "Rule.list" do
    test "/0" do
      [rule_1] = Rule.list()
      assert rule_1.rid == 1
      assert rule_1.name == "Repeated 'front'"
    end

    test "/1" do
      rule_1 = Rule.list(1)
      assert rule_1.rid == 1
      assert rule_1.name == "Repeated 'front'"
    end
  end

  describe "rule 1" do
    test "true :: rule fails" do
      notes = [
        %{
          front: "hello", nid: 1
        },
        %{
          front: "hello", nid: 2
        }
      ]
      note = %{front: "hello", nid: 1}

      assert 1 |> Rule.rule(notes, note) |> Map.fetch!(:fail)
    end

    test "false :: rule passes" do
      notes = [
        %{
          front: "hello", nid: 1
        }
      ]
      note = %{front: "hello", nid: 1}

      refute 1 |> Rule.rule(notes, note) |> Map.fetch!(:fail)

      notes = [
        %{front: "hello", nid: 1}
      ]
      note = %{front: "goodbye", nid: 2}

      refute 1 |> Rule.rule(notes, note) |> Map.fetch!(:fail)
    end
  end
end
