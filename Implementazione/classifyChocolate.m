function type = classifyChocolate(I,classifier)
%classifyChocolate returns the chocolate type
%
% I:            RGB image of a chocolate
% classifier:   chocolate classifier
% type
% rocher-> "d"
% raffaello -> "b"
% rondnoir -> "n"
% reject class -> "r"

CEDD = compute_CEDD(im2uint8(I));
type = string(classifier.predict(CEDD));
end