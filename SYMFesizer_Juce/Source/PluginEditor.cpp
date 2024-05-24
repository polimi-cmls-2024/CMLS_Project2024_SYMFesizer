/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
ProjectAudioProcessorEditor::ProjectAudioProcessorEditor (ProjectAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize(950, 800);

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer
    
    // Sliders and labels description for parameter 1
    sliderChorusRate.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);             // SliderStyle component
    sliderChorusRate.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);    // TextEntryBoxPosition component, read-only boolean, width, height
    sliderChorusRate.setRange(0.0, 4.0, 1.0);                                                             // min, max, interval
    addAndMakeVisible(sliderChorusRate);                                                                  // making sliderChorusRate visible
    labelChorusRate.setText("Chorus Rate (Hz)", juce::dontSendNotification);                              // label text, NotificationType component
    addAndMakeVisible(labelChorusRate);                                                                   // making label 1 visible

    // Sliders and labels description for parameter 2
    sliderChorusDepth.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusDepth.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusDepth.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusDepth);
    labelChorusDepth.setText("Chorus Depth", juce::dontSendNotification);
    addAndMakeVisible(labelChorusDepth);

    // Sliders and labels description for parameter 3
    sliderChorusCentreDelay.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusCentreDelay.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusCentreDelay.setRange(1.0, 100.0, 1.0);
    addAndMakeVisible(sliderChorusCentreDelay);
    labelChorusCentreDelay.setText("Chorus Centre Delay (ms)", juce::dontSendNotification);
    addAndMakeVisible(labelChorusCentreDelay);

    // Sliders and labels description for parameter 4
    sliderChorusFeedback.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusFeedback.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusFeedback.setRange(-1.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusFeedback);
    labelChorusFeedback.setText("Chorus Feedback", juce::dontSendNotification);
    addAndMakeVisible(labelChorusFeedback);

    // Sliders and labels description for parameter 5
    sliderChorusMix.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusMix.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusMix.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusMix);
    labelChorusMix.setText("Chorus Mix", juce::dontSendNotification);
    addAndMakeVisible(labelChorusMix);

    // Sliders and labels description for parameter 6
    sliderPannerValue.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPannerValue.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPannerValue.setRange(-1.0, 1.0, 0.1);
    addAndMakeVisible(sliderPannerValue);
    labelPannerValue.setText("Pan", juce::dontSendNotification);
    addAndMakeVisible(labelPannerValue);
    
    // Sliders and labels description for parameter 7
    sliderCompressorThreshold.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderCompressorThreshold.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderCompressorThreshold.setRange(-50.0, 0.0, 5.0);
    addAndMakeVisible(sliderCompressorThreshold);
    labelCompressorThreshold.setText("Compressor Threshold", juce::dontSendNotification);
    addAndMakeVisible(labelCompressorThreshold);
    
    // Sliders and labels description for parameter 8
    sliderCompressorRatio.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderCompressorRatio.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderCompressorRatio.setRange(1.0, 30.0, 2.0);
    addAndMakeVisible(sliderCompressorRatio);
    labelCompressorRatio.setText("Compressor Ratio", juce::dontSendNotification);
    addAndMakeVisible(labelCompressorRatio);
    
    // Sliders and labels description for parameter 9
    sliderCompressorAttack.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderCompressorAttack.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderCompressorAttack.setRange(0.0, 200.0, 10.0);
    addAndMakeVisible(sliderCompressorAttack);
    labelCompressorAttack.setText("Compressor Attack", juce::dontSendNotification);
    addAndMakeVisible(labelCompressorAttack);
    
    // Sliders and labels description for parameter 10
    sliderCompressorRelease.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderCompressorRelease.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderCompressorRelease.setRange(5.0, 5000.0, 50.0);
    addAndMakeVisible(sliderCompressorRelease);
    labelCompressorRelease.setText("Compressor Release", juce::dontSendNotification);
    addAndMakeVisible(labelCompressorRelease);
    
    
    // Sliders and labels description for parameter 11
    sliderPhaserRate.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);           
    sliderPhaserRate.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);          
    addAndMakeVisible(sliderPhaserRate);            
    labelPhaserRate.setText("Phaser Rate (Hz)", juce::dontSendNotification);            
    addAndMakeVisible(labelPhaserRate);             

    // Sliders and labels description for parameter 12
    sliderPhaserDepth.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserDepth.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserDepth.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderPhaserDepth);
    labelPhaserDepth.setText("Phaser Depth", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserDepth);

    // Sliders and labels description for parameter 13
    sliderPhaserCentreFrequency.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserCentreFrequency.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserCentreFrequency.setRange(1.0, 10000.0, 1.0);
    addAndMakeVisible(sliderPhaserCentreFrequency);
    labelPhaserCentreFrequency.setText("Phaser Centre Frequency (Hz)", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserCentreFrequency);

    // Sliders and labels description for parameter 14
    sliderPhaserFeedback.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserFeedback.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserFeedback.setRange(-1.0, 1.0, 0.1);
    addAndMakeVisible(sliderPhaserFeedback);
    labelPhaserFeedback.setText("Phaser Feedback", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserFeedback);

    // Sliders and labels description for parameter 15
    sliderPhaserMix.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserMix.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserMix.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderPhaserMix);
    labelPhaserMix.setText("Phaser Mix", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserMix);

    
    

    // Attachments linking
    sliderChorusRateAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusRate", sliderChorusRate);       // AudioProcessorValueTreeState inside the Processor, parameter ID (from ParameterLayout), GUI slider
    sliderChorusDepthAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusDepth", sliderChorusDepth);
    sliderChorusCentreDelayAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusCentreDelay", sliderChorusCentreDelay);
    sliderChorusFeedbackAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusFeedback", sliderChorusFeedback);
    sliderChorusMixAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusMix", sliderChorusMix);
    
    sliderPannerValueAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PannerValue", sliderPannerValue);

    sliderCompressorThresholdAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_CompressorThreshold", sliderCompressorThreshold);
    sliderCompressorRatioAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_CompressorRatio", sliderCompressorRatio);
    sliderCompressorAttackAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_CompressorAttack", sliderCompressorAttack);
    sliderCompressorReleaseAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_CompressorRelease", sliderCompressorRelease);
    
    sliderPhaserRateAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserRate", sliderPhaserRate);      
    sliderPhaserDepthAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserDepth", sliderPhaserDepth);
    sliderPhaserCentreFrequencyAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserCentreFrequency", sliderPhaserCentreFrequency);
    sliderPhaserFeedbackAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserFeedback", sliderPhaserFeedback);
    sliderPhaserMixAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserMix", sliderPhaserMix);
    
    
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}

ProjectAudioProcessorEditor::~ProjectAudioProcessorEditor()
{
}

//==============================================================================
void ProjectAudioProcessorEditor::paint (juce::Graphics& g)
{
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::yellow);
    g.setFont (15.0f);
    
    juce::Rectangle<int> titleBounds(0, 0, getWidth(), 50); // Supponiamo che il titolo abbia un'altezza di 50 pixel

    g.drawFittedText ("SYMFesizer Air Guitar!", titleBounds, juce::Justification::centred, 1);
}

void ProjectAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer
    
    // Specifying all GUI components location
    sliderChorusRate.setBounds(10, 80, 100, 100);       // setBounds needs x_position, y_position, width, height
    labelChorusRate.setBounds(10, 50, 130, 20);

    sliderChorusDepth.setBounds(150, 80, 100, 100);
    labelChorusDepth.setBounds(150, 50, 130, 20);

    sliderChorusCentreDelay.setBounds(290, 80, 100, 100);
    labelChorusCentreDelay.setBounds(290, 50, 130, 20);

    sliderChorusFeedback.setBounds(430, 80, 100, 100);
    labelChorusFeedback.setBounds(430, 50, 130, 20);

    sliderChorusMix.setBounds(570, 80, 100, 100);
    labelChorusMix.setBounds(570, 50, 130, 20);

    sliderPannerValue.setBounds(710, 80, 100, 100);
    labelPannerValue.setBounds(710, 50, 130, 20);
    
    sliderCompressorThreshold.setBounds(10, 260, 100, 100);
    labelCompressorThreshold.setBounds(10, 230, 130, 20);
    
    sliderCompressorRatio.setBounds(150, 260, 100, 100);
    labelCompressorRatio.setBounds(150, 230, 130, 20);
    
    sliderCompressorAttack.setBounds(290, 260, 100, 100);
    labelCompressorAttack.setBounds(290, 230, 130, 20);
    
    sliderCompressorRelease.setBounds(430, 260, 100, 100);
    labelCompressorRelease.setBounds(430, 230, 130, 20);
    
    
    sliderPhaserRate.setBounds(10, 440, 100, 100);       
    labelPhaserRate.setBounds(10, 410, 130, 20);

    sliderPhaserDepth.setBounds(150, 440, 100, 100);
    labelPhaserDepth.setBounds(150, 410, 130, 20);

    sliderPhaserCentreFrequency.setBounds(290, 440, 100, 100);
    labelPhaserCentreFrequency.setBounds(290, 410, 130, 20);

    sliderPhaserFeedback.setBounds(430, 440, 100, 100);
    labelPhaserFeedback.setBounds(430, 410, 130, 20);

    sliderPhaserMix.setBounds(570, 440, 100, 100);
    labelPhaserMix.setBounds(570, 410, 130, 20);
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}



