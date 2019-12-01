using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class Advertisement : MonoBehaviour
{
    public VideoClip[] Clips;
    private VideoPlayer _videoPlayer;
    private int _currentVideoIndex = -1;

    void Awake()
    {
        _videoPlayer = GetComponent<VideoPlayer>();
    }

    void Start()
    {
        PlayNext();
    }

    void Update()
    {
        if (!_videoPlayer.isPlaying)
        {
            PlayNext();
        }
    }

    private void PlayNext()
    {
        if (Clips.Length <= 0)
        {
            return;
        }

        _videoPlayer.Stop();

        if (_currentVideoIndex + 1 > Clips.Length - 1)
        {
            _currentVideoIndex = 0;
        }
        else
        {
            _currentVideoIndex++;
        }
        
        _videoPlayer.clip = Clips[_currentVideoIndex];
        _videoPlayer.Play();
    }

}
