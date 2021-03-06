# frozen_string_literal: true

RSpec.describe YARD::Tags::RefTagList do
  before { YARD::Registry.clear }

  it "accepts symbol or string as owner's path and convert it into a proxy" do
    t = Tags::RefTagList.new('author', :String)
    expect(t.owner).to eq P(:String)
  end

  it "accepts proxy object as owner" do
    t = Tags::RefTagList.new('author', P(:String))
    expect(t.owner).to eq P(:String)
  end

  it "returns tags from a proxy object" do
    o = CodeObjects::ClassObject.new(:root, :String)
    t = Tags::Tag.new(:author, 'foo')
    o.docstring.add_tag(t)

    ref = Tags::RefTagList.new('author', :String)
    expect(ref.tags).to eq [t]
    expect(ref.tags.first.text).to eq 'foo'
  end

  it "returns named tags from a proxy object" do
    o = CodeObjects::ClassObject.new(:root, :String)
    p1 = Tags::Tag.new(:param, 'bar1', nil, 'foo')
    p2 = Tags::Tag.new(:param, 'bar2', nil, 'foo')
    p3 = Tags::Tag.new(:param, 'bar3', nil, 'bar')
    t1 = Tags::Tag.new(:return, 'blah')
    o.docstring.add_tag(p1, t1, p2, p3)

    ref = Tags::RefTagList.new('param', :String, 'foo')
    expect(ref.tags).to eq [p1, p2]
    expect(ref.tags.first.text).to eq 'bar1'
  end

  it "all tags should respond to #owner and be a RefTag" do
    o = CodeObjects::ClassObject.new(:root, :String)
    p1 = Tags::Tag.new(:param, 'bar1', nil, 'foo')
    p2 = Tags::Tag.new(:param, 'bar2', nil, 'foo')
    p3 = Tags::Tag.new(:param, 'bar3', nil, 'bar')
    t1 = Tags::Tag.new(:return, 'blah')
    o.docstring.add_tag(p1, t1, p2, p3)

    ref = Tags::RefTagList.new('param', :String)
    ref.tags.each do |t|
      expect(t).to be_kind_of(Tags::RefTag)
      expect(t.owner).to eq o
    end
  end
end
