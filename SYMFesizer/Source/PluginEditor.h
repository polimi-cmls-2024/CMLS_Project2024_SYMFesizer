/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
/**
*/
class ProjectAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    ProjectAudioProcessorEditor (ProjectAudioProcessor&);
    ~ProjectAudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;
   
    
private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    ProjectAudioProcessor& audioProcessor;

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer
    
    // Sliders and labels declaration
    juce::Slider sliderChorusRate;
    juce::Slider sliderChorusDepth;
    juce::Slider sliderChorusCentreDelay;
    juce::Slider sliderChorusFeedback;
    juce::Slider sliderChorusMix;
    
    juce::Slider sliderPannerValue;
    
    juce::Slider sliderCompressorThreshold;
    juce::Slider sliderCompressorRatio;
    juce::Slider sliderCompressorAttack;
    juce::Slider sliderCompressorRelease;
    
    juce::Slider sliderPhaserRate;
    juce::Slider sliderPhaserDepth;
    juce::Slider sliderPhaserCentreFrequency;
    juce::Slider sliderPhaserFeedback;
    juce::Slider sliderPhaserMix;
    
    
    
    
    
    juce::Label labelChorusRate;
    juce::Label labelChorusDepth;
    juce::Label labelChorusCentreDelay;
    juce::Label labelChorusFeedback;
    juce::Label labelChorusMix;
    
    juce::Label labelPannerValue;
    
    juce::Label labelCompressorThreshold;
    juce::Label labelCompressorRatio;
    juce::Label labelCompressorAttack;
    juce::Label labelCompressorRelease;
    
    juce::Label labelPhaserRate;
    juce::Label labelPhaserDepth;
    juce::Label labelPhaserCentreFrequency;
    juce::Label labelPhaserFeedback;
    juce::Label labelPhaserMix;


    // Attachments for linking GUI components to Processor's parameters
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusRateAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusDepthAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusCentreDelayAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusFeedbackAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusMixAttachment;
    
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPannerValueAttachment;
    
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderCompressorThresholdAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderCompressorRatioAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderCompressorAttackAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderCompressorReleaseAttachment;
    
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserRateAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserDepthAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserCentreFrequencyAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserFeedbackAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserMixAttachment;
    
  
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (ProjectAudioProcessorEditor)
};
