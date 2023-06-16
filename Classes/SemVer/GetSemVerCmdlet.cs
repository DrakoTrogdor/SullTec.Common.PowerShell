using System.Management.Automation;

namespace SullTec.Common.PowerShell
{
    [Cmdlet(VerbsCommon.Get,"SemVer")]
    [OutputType(typeof(SemVer))]
    public class GetSemVerCmdlet : Cmdlet
    {
        [Parameter(
            Mandatory = true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string Value { get; set; }

        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing() {}

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            WriteObject(new SemVer(Value));
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing() {}
    }
}
