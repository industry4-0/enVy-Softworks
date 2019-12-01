using UnityEngine;
using Zenject;

public class MainInstaller : MonoInstaller
{
    [Inject]
    private void Construct()
    {
    }

    public override void InstallBindings()
    {
        InstallSingletons();
        InstallFactories();
    }

    private void InstallSingletons()
    {
    }

    private void InstallFactories()
    {
    }
}