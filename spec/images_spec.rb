require_relative 'spec_helper'

describe 'Asciidoctor::Pdf::Converter - Images' do
  context 'SVG' do
    it 'should not leave gap around SVG that specifies viewBox but no width' do
      input = <<~'EOS'
      :pdf-page-size: 200x400
      :pdf-page-margin: 0

      image::viewbox-only.svg[]

      after
      EOS

      pdf = to_pdf input, attributes: { 'imagesdir' => fixtures_dir, 'nofooter' => '' }, analyze: :rect
      (expect pdf.rectangles.size).to eql 1
      (expect pdf.rectangles[0][:point]).to eql [0.0, 200.0]
      (expect pdf.rectangles[0][:width]).to eql 200.0
      (expect pdf.rectangles[0][:height]).to eql 200.0

      pdf = to_pdf input, attributes: { 'imagesdir' => fixtures_dir, 'nofooter' => '' }, analyze: :text
      (expect pdf.strings.size).to eql 1
      (expect pdf.strings[0]).to eql 'after'
      (expect pdf.positions[0][1]).to eql 176.036
    end

    it 'should not leave gap around constrained SVG that specifies viewBox but no width' do
      input = <<~'EOS'
      :pdf-page-size: 200x400
      :pdf-page-margin: 0

      image::viewbox-only.svg[pdfwidth=50%]

      after
      EOS

      pdf = to_pdf input, attributes: { 'imagesdir' => fixtures_dir, 'nofooter' => '' }, analyze: :rect
      (expect pdf.rectangles.size).to eql 1
      (expect pdf.rectangles[0][:point]).to eql [0.0, 200.0]
      (expect pdf.rectangles[0][:width]).to eql 200.0
      (expect pdf.rectangles[0][:height]).to eql 200.0

      pdf = to_pdf input, attributes: { 'imagesdir' => fixtures_dir, 'nofooter' => '' }, analyze: :text
      (expect pdf.strings.size).to eql 1
      (expect pdf.strings[0]).to eql 'after'
      (expect pdf.positions[0][1]).to eql 276.036
    end
  end
end